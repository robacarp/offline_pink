class Features::Index < AdminAction
  get "/features" do
    html IndexPage, features: FeatureQuery.new
  end
end
