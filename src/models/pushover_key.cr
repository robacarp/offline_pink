require "./pushover_key/*"

class PushoverKey < Granite::Base
  extend Granite::Query::BuilderMethods

  include Verification
  adapter pg
  table_name :pushover_keys

  field key : String
  field verified : Bool
  field verification_code : String
  field verification_sent_at : Time

  timestamps

  belongs_to :user

  def can_send?
    ! new_record? && verified?
  end

  def masked
    if (key_ = key) && key_.size > 0
      "#{"*"*24}#{key_[-8..-1]}"
    else
      nil
    end
  end
end
