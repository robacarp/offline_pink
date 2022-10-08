class Domain < BaseModel
  enum Status
    UnChecked = -1
    Stable = 0
    Degraded = 1
    Offline = 2
    SystemFailure = 3
  end

  enum Verification
    UnChecked = -1
    Verified = 0
    Pending = 1
    Invalid = 2
  end

  table :domains do
    column name : String
    column is_valid : Bool = false
    column status_code : Domain::Status = Domain::Status::UnChecked
    column last_monitor_event : Time?

    column verification_status : Domain::Verification = Domain::Verification::UnChecked
    column verification_token : String = ""
    column verification_date : Time = Time::UNIX_EPOCH

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

  def self.build_verification_token
    Base64.urlsafe_encode(Random::Secure.random_bytes(18))
  end
end
