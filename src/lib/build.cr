class Build
  DETAILS_FILE = "build_details.json"

  def self.details
    instance = @@instance ||= new
    instance.details
  end

  getter build_timestamp : String
  getter git_revision : String
  getter version : String

  def initialize
    if File.exists? DETAILS_FILE
      raw_file = File.read DETAILS_FILE
    else
      raw_file = "{}"
    end

    parsed_details = JSON.parse raw_file

    @build_timestamp = parsed_details["build_timestamp"]?.try(&.as_s?) || Time.utc.to_s
    @git_revision = parsed_details["git_revision"]?.try(&.as_s?) || "000000000"
    @version = parsed_details["version"]?.try(&.as_s?) || "development"
  end

  def details : Hash(String, String)
    {
      "build_timestamp" => @build_timestamp,
      "git_revision" => @git_revision,
      "version" => @version,
      "crystal_version" => Crystal::VERSION
    }
  end
end
