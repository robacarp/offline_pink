class GetJob < Mosquito::QueuedJob
  params(check : Check | Nil)

  def perform
    return unless known_check = check
    return unless url = check.uri

    puts "GETing Check##{check.id} : #{url}"

    start_time = Time.now
    response = HTTP::Client.get url
    response_time = Time.now - start_time

    puts "response code: #{response.status_code}"

    GetResult.new(
      check_id: check.id,
      is_up: response.status_code == 200,
      response_code: response.status_code,
      response_time: response_time.milliseconds.to_f32
    ).save
  rescue e : Socket::Error
    GetResult.new(
      check_id: check.id,
      is_up: false,
      response_time: -1.0
    ).save
  end
end
