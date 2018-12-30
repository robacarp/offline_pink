require "./user"

class Domain < BaseModel
  table :domains do
    column name : String
    column is_valid : Bool
    column status_code : Int32

    belongs_to user : User
  end

  enum Status
    UnChecked = -1
    Up = 0
    PartiallyDown = 1
    Down = 2
  end

  def status : Status
    if s = @status_code
      Status.new s
    else
      Status::UnChecked
    end
  end

  def status=(s : Status)
    @status_code = s.value
  end

  # def grouped_monitors
  #   monitors.order(monitor_type: :desc, id: :asc)
  #           .select
  #           .group_by(&.monitor_type)
  # end

  # def up?
  #   ! memoized_hosts.map(&.up?).includes? false
  # end

  # def partial_up?
  #   memoized_hosts.map(&.partial_up?).includes? true
  # end

  # def down?
  #   ! up?
  # end

  def is_valid?
    is_valid
  end

  def is_invalid?
    ! is_valid?
  end
end
