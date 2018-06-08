class PushoverKey < Granite::Base
  extend Granite::Query::BuilderMethods

  adapter :pg
  table_name :pushover_keys

  field key : String
  field verified : Bool
  field verification_code : String
  field verification_sent_at : Time

  timestamps

  belongs_to :user

  def can_send_verification? : Bool
    return true  unless last_verification_sent = @verification_sent_at
    return false unless Time.utc_now - last_verification_sent > 1.hour
    true
  end

  def can_verify? : Bool
    return false unless verification_timestamp = verification_sent_at
    return false unless Time.now - verification_timestamp < 1.hour
    true
  end

  def generate_verification_code
    self.verification_code = Random::Secure.rand(10000..100000).to_s.insert(2, '-')
    self.verified = false
  end

  def verified?
    verified
  end

  def verify!(code : String?)
    return false unless can_verify?

    if @verification_code == code
      self.verified = true
      self.verification_code = nil
      save
    else
      false
    end
  end

  def unverify!
    self.verified = false
    self.verification_code = nil
    save
  end

  def verification_sent!
    self.verification_sent_at = Time.utc_now
    save
  end

  def masked
    if (key_ = key) && key_.size > 0
      "#{"*"*24}#{key_[-8..-1]}"
    else
      nil
    end
  end

end
