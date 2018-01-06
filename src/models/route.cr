require "granite_orm/adapter/pg"

class Route < Granite::ORM::Base
  adapter pg

  field path : String
  field expected_content : String
  field expected_code : Int64
  field use_ssl : Bool
  timestamps

  belongs_to :domain

  def use_ssl?
    use_ssl
  end

  def full_path
    parts = [] of String?
    parts << (use_ssl? ? "https:/" : "http:/")
    parts << domain.name
    parts << path
    parts.compact.join "/"
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
end
