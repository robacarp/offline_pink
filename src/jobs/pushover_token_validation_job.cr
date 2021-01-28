class PushoverSettingsValidationJob < Mosquito::QueuedJob
  params(user_id : Int64)

  def perform
    user = UserQuery.new.find user_id

    return unless key = user.pushover_key

    if device = user.pushover_device
      did_validate = Pushover::API.new.validate_user_key user_key: key, device: device
    else
      did_validate = Pushover::API.new.validate_user_key user_key: key
    end

    update = User::SaveOperation.new user

    if did_validate
      update.valid_pushover_settings.value = User::Validity.new :valid
    else
      update.valid_pushover_settings.value = User::Validity.new :invalid
    end

    update.save!
  end

  def rescheduleable? : Bool
    false
  end
end
