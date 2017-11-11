class GetJob < Mosquito::QueuedJob
  params(check : Check | Nil)

  def perform
    known_check = check
    return unless known_check
    puts "GETing Check##{known_check.id} #{known_check.url}"
  end
end
