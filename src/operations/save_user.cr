class SaveUser < User::SaveOperation
  permit_columns email, pushover_key

  before_save do
    if email.changed?
      validate_uniqueness_of email
      email_valid.value = false
    end

    pushover_key_valid.value = false if pushover_key.changed?
  end

  after_save validate_pushover_token

  def validate_pushover_token(user)
    if pushover_key.changed?
      PushoverTokenValidationJob.new(user.id).enqueue
    end
  end
end
