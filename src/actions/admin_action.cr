require "./browser_action"

abstract class AdminAction < BrowserAction
  route_prefix "/admin"
  ensure_feature_permitted :admin
end
