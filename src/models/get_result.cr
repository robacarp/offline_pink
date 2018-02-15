# require "granite_orm/adapter/pg"
# require "./relative_time"
# 
# class GetResult < Granite::ORM::Base
#   extend Query::BuilderMethods
#   include RelativeTime
# 
#   adapter pg
# 
#   belongs_to :check
# 
#   field is_up : Bool
#   field response_time : Float32
#   field response_code : Int32
#   field found_expected_content : Bool
# 
#   belongs_to :route
#   timestamps
# 
#   table_name "get_results"
# 
#   def is_up?
#     is_up
#   end
# 
#   def checked?
#     ! created_at.nil?
#   end
# 
#   def found_expected_content?
#     found_expected_content
#   end
# end
