require "../../test_helper"

describe "HttpMonitor" do
  it "automatically adds a leading slash" do
    monitor = Generate.http_monitor http_path: "yolo"
    monitor.valid?
    assert monitor.http_path![0] == '/'
  end

  it "uses a default status code" do
    monitor = Generate.http_monitor http_expected_status_code: nil
    monitor.valid?
    assert monitor.http_expected_status_code == 200
  end

  it "allows other status codes" do
    monitor = Generate.http_monitor http_expected_status_code: 306
    monitor.valid?
    assert monitor.http_expected_status_code == 306
  end

  it "only allows appropriate status codes" do
    status_code_error_message = "Status code should be a number between 100 and 550"

    [99, 551, 620, 1000].each do |code|
      monitor = Generate.http_monitor http_expected_status_code: code
      refute monitor.valid?
      assert monitor.errors.map(&.to_s).includes? status_code_error_message
    end

    [100, 550, 200, 301].each do |code|
      monitor = Generate.http_monitor http_expected_status_code: code
      monitor.valid?
      refute monitor.errors.map(&.to_s).includes?(status_code_error_message), "#{code}: #{monitor.errors.map(&.to_s).join(", ")}"
    end
  end

  it "cleans expected content" do
    monitor = Generate.http_monitor http_expected_content: ""
    monitor.valid?
    assert monitor.http_expected_content.nil?

    monitor.http_expected_content = "yolo"
    assert monitor.http_expected_content == "yolo"
  end

  it "renders the full path correctly" do
    domain  = Generate.domain! name: "example.com"
    monitor = Generate.http_monitor domain_id: domain.id, http_path: "/my_path"
    monitor.valid?
    assert monitor.http_full_path == [domain.name, monitor.http_path].join
  end

  it "renders the full url correctly" do
    domain  = Generate.domain! name: "example.com"
    monitor = Generate.http_monitor domain_id: domain.id, http_path: "/my_path", http_use_ssl: true
    monitor.valid?
    assert monitor.http_full_url == "https://example.com/my_path"

    monitor.http_use_ssl = false
    assert monitor.http_full_url == "http://example.com/my_path"
  end

  it "knows if search content is needed" do
    monitor = Generate.http_monitor http_expected_content: "<html>"
    monitor.valid?
    assert monitor.search_content?

    monitor.http_expected_content = nil
    monitor.valid?
    refute monitor.search_content?
  end

  it "knows if the url requires https" do
    monitor = Generate.http_monitor http_use_ssl: true
    assert monitor.https?

    monitor.http_use_ssl = false
    refute monitor.https?
  end

  it "doesnt allow duplicate monitors" do
    duplicate_error_message = "Monitor is already being checked"

    domain = Generate.domain!
    monitor1 = Generate.http_monitor! domain_id: domain.id, http_path: "/", http_use_ssl: true
    refute monitor1.new_record?

    # same domain, path, and ssl
    monitor2 = Generate.http_monitor domain_id: domain.id, http_path: "/", http_use_ssl: true
    refute monitor2.save
    assert monitor2.errors.map(&.to_s).includes? duplicate_error_message

    # same domain, path, different ssl
    monitor3 = Generate.http_monitor domain_id: domain.id, http_path: "/", http_use_ssl: false
    assert monitor3.save
    refute monitor3.errors.any?
  end
end
