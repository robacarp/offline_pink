module Sift
  module BasePolicy
    getter user, object

    macro included
      def self.resolve(action : Symbol) : Symbol
        case action
        when :new, :create     then :create?
        when :show, :read      then :read?
        when :edit, :update    then :update?
        when :delete, :destroy then :delete?
        else
          raise "Sift Unknown Action: #{action}"
        end
      end
    end

    def authorize(action : Symbol) : Bool
      case self.class.resolve(action)
      when :create? then create?
      when :read?   then read?
      when :update? then update?
      when :delete? then delete?
      else
        raise "Sift Unknown Action: #{action}"
      end
    end

    def new? : Bool
      false
    end

    def create? : Bool
      false
    end

    def read? : Bool
      false
    end

    def update? : Bool
      false
    end

    def delete? : Bool
      false
    end
  end
end
