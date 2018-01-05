require "granite_orm/adapter/pg"

class IpAddress < Granite::ORM::Base
  adapter pg
  table_name :ip_addresses

  field address : String
  field version : String
  timestamps

  belongs_to :domain
  has_many :ping_results

  def v4?
    version == "ipv4"
  end

  def v6?
    version == "ipv6"
  end
end
