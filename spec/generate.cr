module Generate
  @@counters = Hash(Symbol, Int32).new { 0 }

  def self.counter(name : Symbol)
    @@counters[name] += 1
  end
end

require "./generators/*"
