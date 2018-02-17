require "../spec_helper"

def domain
  Domain.new(name: "test.zone", user_id: 0_i64).tap(&.save)
end

def http_monitor
  Monitor.new monitor_type: Monitor::VALID_TYPES[:http], domain_id: domain.id
end

describe Monitor do
  it "prepends a slash to a url" do
    monitor = http_monitor
    monitor.http_path = "test"
    monitor.save
    monitor.http_path.should eq "/test"
  end

  it "doesnt prepend a slash if it already exists" do
    monitor = http_monitor
    monitor.http_path = "/test"
    monitor.save
    monitor.http_path.should eq "/test"
  end

  describe "full http_path rendering" do
    it "renders a basic http_path correctly" do
      monitor = http_monitor
      monitor.http_path = "/"
      monitor.save

      monitor.http_full_url.should eq "http://test.zone/"
    end

    it "renders an ssl http_path correctly" do
      monitor = http_monitor
      monitor.http_path = "/"
      monitor.http_use_ssl = true
      monitor.save

      monitor.http_full_url.should eq "https://test.zone/"
    end
  end
end
