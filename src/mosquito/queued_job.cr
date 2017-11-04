module Mosquito
  abstract class QueuedJob < Job
    macro inherited
      macro job_name
        "\{{ @type.id }}".underscore.downcase
      end

      Mosquito::Base.register_job_mapping job_name, {{ @type.id }}

      def self.job_type : String
        job_name
      end

      macro params(*parameters)
        \{%
          parsed_parameters = parameters.map do |parameter|
            type = nil
            simplified_type = nil

            if parameter.is_a? Assign
              name = parameter.target
              value = parameter.value
            elsif parameter.is_a? TypeDeclaration
              name = parameter.var
              value = parameter.value
              type = parameter.type
            else
              raise "Unable to generate for #{parameter}"
            end

            unless type
              raise "Parameter types must be specified explicitly"
            end

            simplified_type = if type.is_a? Union
              without_nil = type.types.reject { |t| t.resolve == Nil }

              if without_nil.size > 1
                raise "Unable to generate a constructor for Union Types: #{without_nil}"
              end

              without_nil.first.resolve

            elsif type.is_a? Path
              type.resolve
            end

            { name: name, value: value, type: type, simplified_type: simplified_type }
          end
        %}

        \{{
          parsed_parameters.map do |parameter|
            getter = "getter #{ parameter["name"] }"
            getter = getter + " : #{ parameter["type"] }" if parameter["type"]
            getter = getter + " = #{ parameter["value"] }" if parameter["value"]

            getter
          end.join("\n").id
        }}

        def initialize
        end

        def initialize(\{{
            parsed_parameters.map do |parameter|
              assignment = "@#{parameter["name"]}"
              assignment = assignment + " : #{parameter["type"]}" if parameter["type"]
              assignment = assignment + " = #{parameter["value"]}" if parameter["value"]
              assignment
            end.join(", ").id
            }})
        end

        def vars_from(config : Hash(String, String))
          \{{
            parsed_parameters.map do |parameter|
              if parameter["simplified_type"] < Mosquito::Model
                "@#{parameter["name"]} = #{parameter["simplified_type"]}.find(config[\"#{parameter["name"]}_id\"])"
              elsif parameter["simplified_type"] == String
                "@#{parameter["name"]} = config[\"#{parameter["name"]}\"]"
              end
            end.join("\n").id
          }}
        end

        def build_task
          task = Mosquito::Task.new(job_name)

          \{% for parameter in parsed_parameters %}
             \{% if parameter["simplified_type"] < Mosquito::Model %}
                if %model = \{{ parameter["name"] }}
                  task.config["\{{ parameter["name"] }}_id"] = %model.id.to_s
                end
             \{% elsif parameter["simplified_type"] < Mosquito::Id %}
                task.config["\{{ parameter["name"] }}"] = \{{ parameter["name"] }}.to_s
             \{% elsif parameter["simplified_type"] < String || parameter["simplified_type"] == String %}
                task.config["\{{ parameter["name"] }}"] = \{{ parameter["name"] }}
             \{% end %}
          \{% end %}

          task
        end
      end
    end

    def enqueue
      task = build_task
      task.store
      self.class.queue.enqueue task
    end

    def enqueue(in delay_interval : Time::Span)
      task = build_task
      task.store
      self.class.queue.enqueue task, in: delay_interval
    end

    def enqueue(at execute_time : Time)
      task = build_task
      task.store
      self.class.queue.enqueue task, at: execute_time
    end
  end
end
