class Domain < Granite::Base
  extend Granite::Query::BuilderMethods
  adapter pg
  table_name :domains

  field name : String
  field is_valid : Bool
  field status_code : Int32

  timestamps

  belongs_to :user
  has_many :monitors, class_name: Monitor
  has_many :hosts, class_name: Host

  before_destroy :destroy_associations

  @is_valid = true

  def validate : Nil
    messages = {
      blank:      "cannot be blank",
      dns_format: "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail",
      assigned:   "must be assigned",
      duplicate:  "is already being checked"
    }

    (add_error :name, messages[:blank];      return) unless @name
    (add_error :name, messages[:blank];      return) if @name.try(&.blank?)
    (add_error :name, messages[:dns_format]; return) if @name.try { |n| ! n.index("/").nil? || n[0...4] == "http" }
    (add_error :user, messages[:assigned];   return) unless @user_id

    if new_record?
      (add_error :name, messages[:duplicate];  return) if Domain.where(user_id: @user_id, name: @name).any?
    end
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

  def monitors
    Monitor.where(domain_id: id)
  end

  def hosts
    Host.where(domain_id: id)
  end

  def monitor_results
    MonitorResult.where(domain_id: id)
  end

  @host_list : Array(Host)?
  def memoized_hosts
    @host_list ||= hosts.select
  end

  def grouped_monitors
    monitors.order(monitor_type: :desc, id: :asc)
            .select
            .group_by(&.monitor_type)
  end

  def up?
    ! memoized_hosts.map(&.up?).includes? false
  end

  def partial_up?
    memoized_hosts.map(&.partial_up?).includes? true
  end

  def down?
    ! up?
  end

  def is_valid?
    is_valid
  end

  def is_invalid?
    ! is_valid?
  end

  def destroy_associations
    hosts.delete
    monitors.delete
    monitor_results.delete
  end
end
