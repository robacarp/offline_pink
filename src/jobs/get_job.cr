class GetJob < Mosquito::QueuedJob
  params(route : Route?)

  def perform
    return unless known_route = route
    return unless url = route.full_path

    puts "GETing Check##{route.id} : #{url}"

    start_time = Time.now
    response = HTTP::Client.get url
    response_time = Time.now - start_time

    puts "response code: #{response.status_code}"

    GetResult.new(
      route_id: route.id,
      is_up: response.status_code == route.expected_code,
      response_code: response.status_code,
      response_time: response_time.milliseconds.to_f32
    ).save
  rescue e : Socket::Error
    GetResult.new(
      route_id: route.id,
      is_up: false,
      response_time: -1.0
    ).save
  end
end
