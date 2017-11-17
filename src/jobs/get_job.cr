class GetJob < Mosquito::QueuedJob
  params(check : Check | Nil)

  def perform
    return unless known_check = check
    return unless host = known_check.host
    return unless path = known_check.url

    url = host + path

    puts "GETing Check##{check.id} : #{url}"

    start_time = Time.now
    response = HTTP::Client.get url
    response_time = Time.now - start_time

    GetResult.new(
      check_id: check.id,
      is_up: response.status_code == 200,
      response_code: response.status_code,
      response_time: response_time.milliseconds.to_f32
    ).save
  end
end
