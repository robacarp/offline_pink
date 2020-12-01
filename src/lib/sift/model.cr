module Sift
  module Model
    macro policy!
      abstract class BasePolicy < ::ApplicationPolicy
        def initialize(@user : User, @object : {{ @type }})
        end
      end

      abstract class BaseCreator
        getter user : User
        getter save : {{ @type }}::SaveOperation

        def initialize(@user, @save)
        end
      end

      #
      # The base class from which all {{ @type }} Scope classes
      # are built.
      #
      # A policy class typically defines a scope sub-class, and
      # the #scoped_query method of a scope is called when a scope
      # is requested. The scope query builds on a bare query object
      # and is used to provide a default scope.
      #
      #     class {{ @type }}Policy < {{ @type }}::BasePolicy
      #       class Scope < {{ @type }}::BaseScope
      #         def scoped_query
      #           query.user_id user
      #         end
      #       end
      #     end
      #
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
