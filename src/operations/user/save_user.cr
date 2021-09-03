class SaveUser < User::SaveOperation
  permit_columns email, pushover_key, pushover_device

  before_save do
    if email.changed?
      validate_uniqueness_of email
      email_valid.value = User::Validity::Unchecked
    end

    if pushover_key.changed? || pushover_device.changed?
      valid_pushover_settings.value = User::Validity::Unchecked
    end
  end

  after_save validate_pushover_token

  def validate_pushover_token(user)
    if pushover_key.changed? || pushover_device.changed?
      PushoverSettingsValidationJob.new(user.id).enqueue
    end
  end
end
