require "granite_orm/adapter/pg"

class IpAddress < Granite::ORM::Base
  adapter pg
  table_name :ip_addresses

  field address : String
  field version : String
  timestamps

  belongs_to :domain

  before_destroy :destroy_associations

  @last_result : PingResult?

  def v4?
    version == "ipv4"
  end

  def v6?
    version == "ipv6"
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

  def ping_results
    PingResult.where(ip_address_id: id)
  end

  def destroy_ping_results
    ping_results.delete
  end

  def destroy_associations
    destroy_ping_results
  end
end
