module Features
  @[Flags]
  enum Feature
    Active
    UsePushover
    Admin = 4096

    def to_a
      features = [] of String

      {% for member in @type.constants %}
        {% if member.stringify != "All" %}
          if includes?({{ @type }}::{{ member }})
            features << {{ member.stringify.downcase }}
          end
        {% end %}
      {% end %}

      features
    end
  end

  alias FeatureName = Feature | Symbol | String

  def enabled_features : Feature
    Feature.new(self.features || 0)
  end

  def featureify(feature : FeatureName) : Feature
    case feature
    when Feature
      feature
    when Symbol
      Feature.parse feature.to_s
    when String
      Feature.parse feature
    else
      raise "Can not featureify a #{feature.class}"
    end
  end

  def set_features(features : Array(FeatureName))
    self.features = 0
    features.map  { |feature| featureify feature }
            .each { |feature| enable feature }
  end

  def set_features!(features : Array(FeatureName))
    set_features features
    save
  end


  def is?(*args)
    can? *args
  end

  def can?(feature : FeatureName) : Bool
    enabled_features.includes? featureify feature
  end


  def enable(feature : FeatureName) : Nil
    feature = featureify feature
    unless can? feature
      self.features = (enabled_features ^ feature).to_i
    end
  end

  def enable!(feature : FeatureName) : Nil
    enable feature
    save
  end


  def disable(feature : FeatureName) : Nil
    feature = featureify feature
    if can? feature
      self.features = (enabled_features ^ feature).to_i
    end
  end

  def disable!(feature : FeatureName) : Nil
    disable feature
    save
  end
end
