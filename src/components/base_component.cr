abstract class BaseComponent < Lucky::BaseComponent
  include Featurette::LayoutHelpers(Feature)
  include ClassList
end
