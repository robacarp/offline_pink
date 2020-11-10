class Region < BaseModel
  table :regions do
    column name : String
  end

  @@default_region : self?

  def self.default_region
    @@default_region ||= RegionQuery.first
  end
end
