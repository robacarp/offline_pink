class ApplicationPolicy < PinkAuthorization::Policy
  def logged_in?
    ! current_user.id.nil?
  end

  def activated?
    logged_in? && current_user.activated?
  end

  def user_is_owner?
    activated? && object.user_id == current_user.id
  end

  def user_owns_related_domain?
    return unless domain_id = object.domain_id
    return unless domain = Domain.find domain_id
    domain.user_id == current_user.id
  end

  def show?; false; end
  def create?; false; end
  def edit?; false; end
  def update?; false; end
  def destroy?; false; end
  def delete?; false; end

  def new?; logged_in?; end
end
