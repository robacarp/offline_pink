module Featurette
  class_getter configuration = Configuration.new

  def self.configure : Nil
    yield configuration
  end

  class Configuration
  end
end

