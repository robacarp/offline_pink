class GrantFeature < Featurette::EnabledFeature::SaveOperation
  needs feature : Featurette::Feature

  permit_columns user_id

  before_save validate_grant_doesnt_already_exist
  before_save validate_user_exists

  before_save do
    feature_id.value = feature.id
  end

  def validate_grant_doesnt_already_exist
    existing_grant = Featurette::EnabledFeatureQuery.new
      .user_id.nilable_eq(user_id.value)
      .feature_id(feature.id)
      .first?

    if existing_grant
      user_id.add_error "is already granted"
    end
  end

  def validate_user_exists
    if id = user_id.value
      user = UserQuery.new.id(id).first?
      user_id.add_error "is invalid" unless user
    else
      validate_required user_id
    end
  end
end
