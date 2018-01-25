require "granite_orm/adapter/pg"

class Domain < Granite::ORM::Base
  adapter pg

  field name : String
  timestamps

  belongs_to :user
  has_many :routes

  before_destroy :destroy_associations

  def validate : Nil
    blank_name = true
    if name = @name
      blank_name = name.blank?
    end

    add_error :name, "cannot be blank" if blank_name
    return if blank_name

    malformed_name = true
    if name = @name
      malformed_name = ! name.index("/").nil?
      malformed_name ||= name[0...4] == "http"
    end

    if malformed_name
      add_error :name, "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"
    end
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

  def destroy_associations
    ip_addresses.map(&.destroy)
    routes.map(&.destroy)
  end
end
