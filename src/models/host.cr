require "granite_orm/adapter/pg"

class Host < Granite::ORM::Base
  adapter pg
  table_name :hosts

  field address : String
  field ip_version : String
  timestamps

  belongs_to :domain

  before_create :guess_version
  before_destroy :destroy_associations

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
    # PingResult.where(ip_address_id: id)
  end

  def destroy_ping_results
    # ping_results.delete
  end

  def destroy_associations
    # destroy_ping_results
  end

  def guess_version
    if address = @address
      @ip_version = address.includes?(":") ? "ipv6" : "ipv4"
    end
  end
end
