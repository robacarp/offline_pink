require "log"

class PoorDNS
  Log = ::Log.for(self)

  def self.query(host : String, record_type : String) : Array(String)
    instance = new host, record_type
    instance.query
  end

  getter zone, record_type

  def initialize(@zone : String, @record_type : String)
  end

  def query
    output, error = IO::Memory.new, IO::Memory.new

    Log.info { "calling dig #{zone} #{record_type}" }

    status = Process.run(
      "dig",
      args: [zone, "-t#{record_type}"],
      output: output,
      error: error,
    )

    unless status.success?
      Log.info { "dig process failed:" + error.to_s }
      raise RuntimeError.new("dig failed")
    end

    parse output
  end

  def parse(output : IO::Memory)
    parse output.to_s
  end

  def parse(output : String) : Array(String)
    lines = output.split('\n').reject(&.blank?)
    no_response = [] of String

    # look for the header, which contains the resolve status
    while line = lines.shift?
      if line =~ /->>HEADER<<-/
        if line.split(",")[1] != " status: NOERROR"
          Log.error { "dig 'status: NOERROR' missing: #{line}" }
          return no_response
        end

        break
      end
    end

    # fast forward to the answer section
    while line = lines.shift?
      break if line =~ /ANSWER SECTION/
    end

    # schlurp up the answers
    answers = [] of String

    while line = lines.shift?
      break if line.starts_with?(";;")
      answers << line
    end

    answers
  end
end
