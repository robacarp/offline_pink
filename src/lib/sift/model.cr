module Sift
  module Model
    macro policy!
      abstract class BasePolicy < ::ApplicationPolicy
        def initialize(@user : User, @object : {{ @type }})
        end
      end

      abstract class BaseScope
        getter user : User
        getter query :  {{ @type }}Query

        def initialize(@user, @query)
        end

        abstract def scoped_query
      end
    end
  end
end
