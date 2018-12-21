class Session::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  post "/session/new" do
    SessionForm.new(params).submit do |form, authenticated_user|
      if authenticated_user
        create_session for: authenticated_user
        flash.success = "You're now signed in"
        # Authentic.redirect_to_originally_requested_path(self, fallback: Home::Index)
        redirect to: Home::Index
      else
        flash.failure = "Sign in failed"
        render NewPage, form: form
      end
    end
  end
end
