class Admin::Features::Delete < AdminAction
  delete "/feature/:id" do
    feature = Featurette::FeatureQuery.new.find(id)
    feature.delete
    flash.success = "Deleted feature \"#{feature.name}\""
    redirect Features::Index
  end
end
