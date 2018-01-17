require "../spec_helper"

def domain
  Domain.new(name: "test.zone", user_id: 0_i64).tap(&.save)
end

describe Route do
  it "prepends a slash to a url" do
    route = Route.new path: "test", domain_id: 0_i64
    route.save
    route.path.should eq "/test"
  end

  it "doesnt prepend a slash if it already exists" do
    route = Route.new path: "/test", domain_id: 0_i64
    route.save
    route.path.should eq "/test"
  end

  describe "full path rendering" do
    it "renders a basic path correctly" do
      route = Route.new path: "/", domain_id: domain.id
      route.save

      route.full_path.should eq "http://test.zone/"
    end

    it "renders an ssl path correctly" do
      route = Route.new path: "/", use_ssl: true, domain_id: domain.id
      route.save

      route.full_path.should eq "https://test.zone/"
    end
  end
end
