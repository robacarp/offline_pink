module Features
  @[Flags]
  enum Feature
    Admin
    Active
  end

  def enabled_features : Feature
    Feature.new(self.features || 0)
  end

  def featureify(feature : Symbol) : Feature
    Feature.parse feature.to_s
  end


  def is?(*args)
    can? *args
  end

  def can?(feature : Symbol) : Bool
    can? featureify feature
  end

  def can?(feature : Feature) : Bool
    enabled_features.includes? feature
  end


  def enable!(feature : Symbol) : Nil
    enable! featureify feature
  end

  def enable!(feature : Feature) : Nil
    unless can? feature
      self.features = (enabled_features ^ feature).to_i
      save
    end
  end

  def disable!(feature : Symbol) : Nil
    disable! featureify feature
  end

  def disable!(feature : Feature) : Nil
    if can? feature
      self.features = (enabled_features ^ feature).to_i
      save
    end
  end
end
