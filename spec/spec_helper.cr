require "spec"
require "amber"
require "../config/*"
require "../src/ext/extensions"
require "../src/controllers/application_controller"
require "../src/controllers/**"
require "../src/mailers/**"
require "../src/models/**"
require "../src/policies/**"

Spec.before_each do
  Route.clear
  User.clear
  PingResult.clear
  GetResult.clear
  Check.clear
end
