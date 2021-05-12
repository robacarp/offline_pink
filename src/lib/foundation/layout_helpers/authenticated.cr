module Foundation::LayoutHelpers::Authenticated
  macro included
    needs current_user : User
    needs admin_user : User?
  end
end
