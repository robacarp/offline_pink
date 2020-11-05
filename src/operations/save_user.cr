class SaveUser < User::SaveOperation
  permit_columns email
end
