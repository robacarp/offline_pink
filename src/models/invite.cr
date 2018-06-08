class Invite < Granite::Base
  extend Query::BuilderMethods

  adapter pg
  table_name invites

  field code : String
  field uses_remaining : Int64

  timestamps

  before_save generate_code

  def generate_code
    @code = Random::Secure.hex 10
  end

  def invited_user_count
    0
  end

  def use!
    true
  end
end
