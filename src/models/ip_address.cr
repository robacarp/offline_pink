require "granite_orm/adapter/pg"

class IpAddress < Granite::ORM::Base
  adapter pg
  table_name :ip_addresses

  field address : String
  timestamps

  belongs_to :domain
  has_many :ping_results

  def v4?
  end

  def v6?
  end
end
