class PingJob < Mosquito::QueuedJob
  params(
    check : Check | Nil,
    str : String = "test",
    number : Int32 = 3
  )

  def perform
    known_check = check
    return unless known_check
    puts "Pinging: #{known_check.host}"
  end
end
