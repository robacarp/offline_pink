require "granite_orm/adapter/pg"

class Domain < Granite::ORM::Base
  adapter pg

  field name : String
  timestamps

  belongs_to :user
  has_many :routes
  has_many :ping_results, through: :ip_addresses

  # has_many :ip_addresses, class: IpAddress
  def ip_addresses : Array(IpAddress)
    IpAddress.all("WHERE domain_id = ?", id)
  end

  def ping_results : Array(PingResult)
    query = <<-SQL
      JOIN ip_addresses ON ip_addresses.id = ping_result.ip_address_id
      WHERE
        ip_addresses.domain_id = ?
    SQL

    PingResult.all query
  end
end
