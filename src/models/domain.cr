require "./user"

class Domain < BaseModel
  avram_enum Status do
    UnChecked = -1
    Up = 0
    PartiallyDown = 1
    Down = 2
  end

  table :domains do
    column name : String
    column is_valid : Bool = false
    column status_code : Domain::Status = Domain::Status.new(:un_checked).to_i

    belongs_to user : User?
    belongs_to organization : Organization?
    polymorphic owner, associations: [:user, :organization]

    has_many icmp_monitors : Monitor::Icmp
    has_many http_monitors : Monitor::Http
  end

  policy!

  def monitors : Array(Monitor::Base)
    list = [] of Monitor::Base

    icmp_monitors.each do |monitor|
      list << monitor
    end

    http_monitors.each do |monitor|
      list << monitor
    end

    list
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
