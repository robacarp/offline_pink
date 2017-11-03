module Mosquito
  class Runner
    def self.start
      new.run
    end

    getter queues

    def initialize
      @queues = [] of Queue
    end

    def run
      puts "Mosquito is buzzing..."

      while true
        fetch_queues
        enqueue_scheduled
        work
      end
    end

    private def fetch_queues
      new_queues = Queue.list_queues.map { |name| Queue.new name }

      if new_queues != @queues
        if new_queues.any?
          # puts "Queues: #{new_queues.map(&.name).join(", ")}"
        end

        @queues = new_queues
      end
    end

    private def enqueue_scheduled
      queues.each do |q|
        overdue_tasks = q.dequeue_scheduled
        next unless overdue_tasks.any?
        puts "Found #{overdue_tasks.size} overdue tasks:"

        overdue_tasks.each do |task|
          puts "\t Enqueueing #{task.id}"
          q.enqueue task
        end
      end
    end

    private def work
      queues.each do |q|
        run_task q
      end
    end

    private def run_task(q : Queue)
      task = q.dequeue
      return unless task

      puts "Running task #{task.id} from #{q.name}"

      task.run

      if task.succeeded?
        puts "#{task.id} succeeded"
        q.forget task
        task.delete
      else
        print "#{task.id} failed, "

        if task.rescheduleable?
          interval = task.reschedule_interval
          next_execution = Time.now + interval
          puts "rescheduling for #{next_execution} (#{interval})"
          q.reschedule task, next_execution
        else
          puts "cannot reschedule"
          q.banish task
        end
      end
    end
  end
end
