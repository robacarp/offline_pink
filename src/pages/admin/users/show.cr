class Admin::Users::ShowPage < AuthLayout
  needs user : User

  def content
    small_frame do
      header_and_links do
        h1 user.email
      end

      if user.domains.any?
        owned_domain_info
      end

      user_enabled_features
    end
  end

  def owned_domain_info
    h1 "Domains"
    hr

    user.domains.each do |domain|
      para domain.name
    end

    hr
  end

  def user_enabled_features
    h1 "Enabled Features"
    hr

    user.features.each do |feature|
      para feature.name
    end
  end

end
