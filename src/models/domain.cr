require "granite_orm/adapter/pg"

class Domain < Granite::ORM::Base
  adapter pg

  field name : String
  timestamps

  belongs_to :user
  has_many :routes
  has_many :ip_addresses, class: IpAddress
  has_many :ping_results, through: :ip_addresses
end
