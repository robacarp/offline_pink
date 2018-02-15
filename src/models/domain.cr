class Domain < Granite::ORM::Base
  extend Query::BuilderMethods
  adapter pg

  field name : String
  field is_valid : Bool

  timestamps

  belongs_to :user
  has_many :monitors

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

  def monitors
    Monitor.where(domain_id: id)
  end

  def grouped_monitors
    monitors.order(monitor_type: :desc, id: :asc)
            .select
            .group_by(&.monitor_type)
    # {} of String => Array(Monitor)
  end

  # has_many :ip_addresses, class: IpAddress
  def ip_addresses : Array(IpAddress)
    IpAddress.all "WHERE domain_id = ?", id
  end

  # has_many :ping_results, through: :ip_addresses
  def ping_results : Array(PingResult)
    query = <<-SQL
      JOIN ip_addresses ON ip_addresses.id = ping_results.ip_address_id
      WHERE
        ip_addresses.domain_id = ?
    SQL

    PingResult.all query, id
  end

  def last_result : PingResult?
    query = <<-SQL
      JOIN ip_addresses ON ip_addresses.id = ping_results.ip_address_id
      WHERE
        ip_addresses.domain_id = ?
      ORDER BY created_at DESC
      LIMIT 1
    SQL

    result_set = PingResult.all query, id
    if result_set.any?
      result_set.first
    end
  end

  def up?
    true
  end

  def checked?
    ping_results.any?
  end

  def is_valid?
    is_valid
  end

  def is_invalid?
    ! is_valid?
  end

  def destroy_associations
    ip_addresses.map(&.destroy)
  end
end
