class User < BaseModel
  include Carbon::Emailable
  include Foundation::ModelHelpers::Authentication

  enum Validity
    Unchecked = 1024
    Valid = 0
    Invalid = 1
  end

  table :users do
    column email : String
    column encrypted_password : String

    column pushover_key : String?
    column pushover_device : String?

    column valid_pushover_settings : User::Validity = User::Validity.new(:unchecked).to_i
    column email_valid : User::Validity = User::Validity::Unchecked

    has_many domains : Domain
    has_many memberships : Membership
    has_many organizations : Organization, through: [:memberships, :user]

    has_many enabled_features : EnabledFeature
    has_many features : Feature, through: [:enabled_features, :feature]
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end

  def activated?
    is? :active
  end

  def valid_pushover_settings?
    valid_pushover_settings == User::Validity::Valid
  end
end
