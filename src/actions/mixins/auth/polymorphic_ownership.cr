struct NamedValue
  property name : String
  property value : String

  def initialize(@name, @value)
  end

  def to_tuple
    { name, value }
  end
end

struct DecodedOwner
  getter klass : User.class | Organization.class
  getter id : Int64

  def initialize(@klass, @id)
  end

  def initialize(klass, id : String)
    initialize klass, id.to_i64
  end

  def find : User | Organization
    query.find id
  end

  def query : UserQuery | OrganizationQuery
    case klass
    when User
      UserQuery.new
    when Organization
      OrganizationQuery.new
    end
  end

  def holds?(candidate : User.class | Organization.class)
    klass == candidate
  end

  def matches?(candidate : User)
  end
end

module PolymorphicOwnership
  macro included
    expose organizations
    expose possible_owners
  end

  def organizations : OrganizationQuery
    user = current_user

    if user.nil?
      OrganizationQuery.new.none
    else
      OrganizationQuery.new
        .where_memberships(MembershipQuery.new.user_id(user.id))
    end
  end

  def possible_owners : Array(NamedValue)
    user = current_user

    return [] of NamedValue if user.nil?

    owner_objects = [] of User | Organization
    owner_objects << user

    organizations.each do |organization|
      owner_objects << organization
    end

    owner_objects.map do |obj|
      gid = "gid://#{obj.class.name}/#{obj.id}"

      case obj
      when User
        NamedValue.new(obj.email, gid)
      when Organization
        NamedValue.new(obj.name, gid)
      end
    end.compact
  end

  def decode_owner(global_id : String) : DecodedOwner
    unless global_id.starts_with? "gid://"
      raise "#{global_id} is not a global id"
    end

    klass, id = global_id[6..].split '/'

    case klass
    when "User"
      DecodedOwner.new User, id
    when "Organization"
      DecodedOwner.new Organization, id
    else
      raise "Unknown class: #{klass}"
    end
  end
end
