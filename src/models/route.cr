require "granite_orm/adapter/pg"

class Route < Granite::ORM::Base
  adapter pg

  field path : String
  field expected_content : String
  field expected_code : Int64
  field use_ssl : Bool
  timestamps

  belongs_to :domain

  before_save :enforce_leading_slash

  def validate : Nil
    # status code shoud be a number 100-550
    if code = expected_code
      unless 100 < code < 550
        add_error :expected_code, "Status code should be a number between 100 and 550"
      end
    end
  end

  def use_ssl?
    use_ssl
  end

  def search_for_content?
    search_text = expected_content
    search_text && ! search_text.blank?
  end

  def full_path
    protocol = use_ssl? ? "https://" : "http://"
    [protocol, domain.name, path].compact.join
  end

  def last_result
    @last_result ||= begin
      query = <<-SQL
        WHERE get_results.route_id = ?
        ORDER BY created_at DESC
        LIMIT 1
      SQL

      results = GetResult.all query, [id]
      if results.any?
        results.first
      else
        GetResult.new
      end
    end
  end

  private def enforce_leading_slash
    if path = @path
      if path.blank?
        @path = "/"
      elsif path[0] != '/'
        @path = "/" + path
      end
    end
  end
end
