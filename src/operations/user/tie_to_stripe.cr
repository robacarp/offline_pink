class User::ConnectToStripe < User::SaveOperation
  permit_columns stripe_id 
end
