abstract class Query::Executor::Base
  def initialize(@sql : String, @args = [] of DB::Any)
  end

  def raw_sql : String
    @sql
  end

  def log(*stuff)
    puts
    puts *stuff
    puts
  end
end
