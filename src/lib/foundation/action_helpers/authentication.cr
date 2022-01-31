require "./allow_guests"
require "./original_request_preserver"
require "./redirect_signed_in_users"
require "./require_signed_in"
require "./sign_in"
require "./test_backdoor"

module Foundation::ActionHelpers::Authentication(UserModel, UserQuery)
  macro included
    include Foundation::ActionHelpers::SignIn(UserModel, UserQuery)
    include Foundation::ActionHelpers::RequireSignedIn
    include Foundation::ActionHelpers::TestBackdoor
    include Foundation::ActionHelpers::OriginalRequestPreserver(UserModel)

    expose current_user
    expose admin_user
  end

  macro redirect_signed_in_users
    include Foundation::ActionHelpers::RedirectSignedInUsers
  end

  macro allow_guests
    include Foundation::ActionHelpers::AllowGuests
  end
end
