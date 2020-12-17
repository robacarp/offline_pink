class Monitor::Http
  include JSON::Serializable
  include JsonHelpers

  @[JSON::Field]
  property ssl : Bool = true

  @[JSON::Field]
  property path : String = "/"

  @[JSON::Field]
  property expected_status_code : Int64 = 200

  @[JSON::Field]
  property expected_content : String?

  def initialize
  end

  def ssl?
    ssl
  end

  def string_config : String
    String.build do |s|
      s << "(SSL) " if ssl?

      s << "'"
      s << path
      s << "' : "

      s << expected_status_code
    end
  end

  def summary : String
    String.build do |s|
      s << "http"
      s << "s" if ssl?

      if path
        s << " "
        s << path
      end

      s << " => "
      s << expected_status_code
      s << " (with search content)" unless expected_content.blank?
    end
  end

  def to_any : JSON::Any
    any({
      "ssl" => any(ssl),
      "path" => any(path),
      "expected_status_code" => any(expected_status_code),
      "expected_content" => any(expected_content)
    })
  end
end
