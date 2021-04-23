class Features::New < AdminAction
  get "/features/new" do
    html NewPage, save: SaveFeature.new
  end
end
