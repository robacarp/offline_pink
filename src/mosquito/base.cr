module Mosquito
  alias Model = Granite::ORM::Base
  alias Id = Int64 | Int32

  class Base
    @@mapping = {} of String => Mosquito::Job.class

    def self.register_job_mapping(string, klass)
      @@mapping[string] = klass
    end

    def self.job_for_type(type : String) : Mosquito::Job.class
      @@mapping[type]
    end
  end
end
