module StripeUserLookup
  def user : User
    if user_ = user?
      user_
    else
      raise "No user found for stripe_id: #{stripe_customer_id}"
    end
  end

  def user? : User?
    UserQuery.new.stripe_id(stripe_customer_id).first?
  end

  macro included
    needs stripe_customer_id : String
  end
end
