class Domain < BaseModel
  avram_enum Status do
    UnChecked = -1
    Stable = 0
    Degraded = 1
    Offline = 2
    SystemFailure = 3
  end

  table :domains do
    column name : String
    column is_valid : Bool = false
    column status_code : Domain::Status = Domain::Status.new(:un_checked).to_i
    column last_monitor_event : Time?

    belongs_to user : User?
    belongs_to organization : Organization?
    polymorphic owner, associations: [:user, :organization]

    has_many log_entries : LogEntry

    has_many monitors : Monitor
  end

  def is_valid?
    is_valid
  end

  def is_invalid?
    ! is_valid?
  end

  def last_monitor_output
    last_run = LogEntryQuery.new
      .domain_id(id)
      .monitor_event
      .select_max

    if last_run
      LogEntryQuery.new
        .domain_id(id)
        .monitor_event(last_run)
    else
      LogEntryQuery.new.none
    end
  end
end
