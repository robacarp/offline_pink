require "granite_orm/adapter/pg"

class Host < Granite::ORM::Base
  extend Query::BuilderMethods

  adapter pg
  table_name :hosts

  field address : String
  field ip_version : String
  timestamps

  belongs_to :domain
  has_many :monitor_results

  before_create :guess_version
  before_destroy :destroy_associations

  def v4?
    version == "ipv4"
  end

  def v5?
    false
  end

  def v6?
    version == "ipv6"
  end

  def monitor_results
    MonitorResult.where(host_id: id)
  end

  def last_result
    @last_result ||= begin
      if result = ping_results.order(created_at: :desc).first
        result
      else
        PingResult.new
      end
    end
  end

  def destroy_associations
    monitor_results.delete
  end

  def guess_version
    if address = @address
      @ip_version = address.includes?(":") ? "ipv6" : "ipv4"
    end
  end
end
