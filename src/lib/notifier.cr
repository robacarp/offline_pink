module Notify
  class User
    private getter user

    def initialize(@user : ::User)
    end

    def send(message : String, title : String? = nil)
      PushNotificationJob.new(user.id, title, message).enqueue
    end
  end

  class Domain
    private getter domain

    def initialize(@domain : ::Domain)
    end

    def update_stability
      for_users do |user|
        User.new(user).send "#{domain.name} is #{domain.status_code}", "Offline.pink domain stability"
      end
    end

    def update_validity
      for_users do |user|
        validity = "valid"
        validity = "invalid" unless domain.is_valid?

        User.new(user).send "#{domain.name} is now marked as #{validity} for monitoring", "Offline.pink service monitoring"
      end
    end

    private def for_users
      users = [] of ::User?
      users << domain.user!

      if (org = domain.organization!)
        org.users!.each do |user|
          users << user
        end
      end

      users.compact.each do |user|
        yield user
      end
    end
  end
end
