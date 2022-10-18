require "./shards"

module OfflinePink
  SUBSCRIPTION_PRICE = 8.75

  def self.domain
    case
    when domain_ = ENV["DOMAIN"]?
      domain_
    else
      "#{Lucky::ServerSettings.host}:#{Lucky::ServerSettings.port}"
    end
  end
end

# Load the asset manifest in public/mix-manifest.json
# Lucky::AssetHelpers.load_manifest

require "../config/server"

require "./app_database"
require "../config/**"
require "./handlers/**"
require "./policies/application_policy"
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./policies/**"

require "./jobs/**"
require "./queries/**"
require "./operations/mixins/**"
require "./operations/**"
require "./serializers/base_serializer"
require "./serializers/**"
require "./emails/base_email"
require "./emails/**"
require "./actions/mixins/**"
require "./actions/**"
require "./pages/layout_helpers/*"
require "./components/base_component"
require "./components/**"
require "./pages/base_layout"
require "./pages/**"
require "../db/migrations/**"
require "./app_server"
