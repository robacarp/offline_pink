abstract class ApplicationPolicy(T)
  getter user
  getter record : T

  def initialize(@user : User, @record : T)
  end

  def index? : Bool
    false
  end

  def show? : Bool
    false
  end

  def create? : Bool
    false
  end

  def new? : Bool
    create?
  end

  def update? : Bool
    false
  end

  def edit? : Bool
    update?
  end

  def delete? : Bool
    false
  end
end

