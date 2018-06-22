module Amber
  def self.url
    case Amber.env
    when .development?
      "http://localhost:3000"
    when .production?
      "https://offline.pink"
    else
      "http://example"
    end
  end
end
