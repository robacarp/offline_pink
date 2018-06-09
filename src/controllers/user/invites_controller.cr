class User::InvitesController < ApplicationController
  authorize_with User::InvitesPolicy, User

  # When a user registered without an invite and wants
  # to add an invite to their account to activate it

  def edit
    redirect_to root_path if current_user.is? :active
    authorize current_user
    invite = Invite.new
    render "edit.slang"
  end

  def update
    user = current_user
    authorize user

    if invite = Invite.where(code: params["invite_code"]).first
      if invite.use!
        user.invite_id = invite.id
        user.enable! :active
        user.save

        flash["success"] = "Success! Thanks for adding your invite code."

        return redirect_to root_path
      else
        flash["warning"] = "That invite code is no longer valid."
        return render "edit.slang"
      end
    else
      invite = Invite.new
      flash["warning"] = "That invite code doesn't exist."
      return render "edit.slang"
    end
  end
end
