class Domain::SetInvalid < Domain::SaveOperation
  before_save do
    is_valid.value = false
  end
end
