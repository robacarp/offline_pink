abstract class ApplicationPolicy
  getter user, object

  def authorize(action : Symbol)
    case action
    when :create then create?
    when :show   then read?
    when :update then update?
    when :delete then delete?
    end
  end

  def user_is_owner
    object.user_id == user.id
  end

  def create?
    user_is_owner
  end

  def read?
    user_is_owner
  end

  def update?
    user_is_owner
  end

  def delete?
    user_is_owner
  end
end
