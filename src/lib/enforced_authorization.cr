module EnforcedAuthorization
  macro included
    after ensure_authorized
  end

  @_authorization_enforced = false

  def _authorized!
    @authorization_enforced = true
  end

  def ensure_authorized
    raise "Not Authorized" unless @authorization_enforced
    continue
  end
end
