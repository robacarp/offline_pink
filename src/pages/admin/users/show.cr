class Admin::Users::ShowPage < AuthLayout
  needs user : User

  def content
    small_frame do
      header_and_links user.email do
        link "Assume User", to: Admin::Users::Impersonate.with(user), data_confirm: "Are you sure?"
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

    ul do
      user.enabled_features.each do |grant|
        li do
          link grant.feature.name, to: Features::Show.with(grant.feature)
        end
      end
    end
  end

end
