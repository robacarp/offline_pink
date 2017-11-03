class PingJob < Mosquito::Job
  params(
    check : Check | Nil,
    str : String = "test",
    number : Int32 = 3
  )

  def perform
    puts "Ping Job"
  end
end
