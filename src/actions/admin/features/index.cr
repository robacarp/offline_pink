class Admin::Features::Index < AdminAction
  get "/features" do
    html IndexPage, features: Featurette::FeatureQuery.new
  end
end
