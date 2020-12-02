class SaveUser < User::SaveOperation
  permit_columns email

  before_save do
    if email.changed?
      validate_uniqueness_of email
    end
  end
end
