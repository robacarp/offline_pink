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

  def use_ssl?
    use_ssl
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
      if path[0] != '/'
        @path = "/" + path
      end
    end
  end
end
