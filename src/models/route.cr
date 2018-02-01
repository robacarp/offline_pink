require "granite_orm/adapter/pg"

class Route < Granite::ORM::Base
  extend Query::BuilderMethods
  adapter pg

  field path : String
  field expected_content : String
  field expected_code : Int64
  field use_ssl : Bool
  timestamps

  belongs_to :domain
  has_many :get_results

  before_save :enforce_leading_slash
  before_destroy :destroy_associations

  def validate : Nil
    messages = {
      invalid_code: "Status code should be a number between 100 and 550",
      assigned:     "must be assigned",
      duplicate:    "is already being checked",
      blank:        "must be present"
    }

    enforce_leading_slash

    # status code shoud be a number 100-550
    (add_error :code,   messages[:invalid_code]; return) if @expected_code.try { |c| ! (100 <= c < 550) }
    (add_error :domain, messages[:assigned];     return) unless @domain_id
    (add_error :path,   messages[:blank];        return) unless @path && ! @path.try(&.blank?)

    duplicate_routes = Route.all("WHERE domain_id = ? AND path = ?", [@domain_id, @path])
    (add_error :route,  messages[:duplicate];  return) if duplicate_routes.any?
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

  def destroy_associations
    get_results.map(&.destroy)
  end
end
