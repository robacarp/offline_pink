class DomainOfflineJob < Mosquito::QueuedJob
  params(
    result : PingResult?
  )

  def perform
    return unless known_result = result
    return unless ip_address = result.ip_address
    return unless domain = ip_address.domain
    return unless user = domain.user
    DomainOfflineNotificationMailer.new(user, domain, result).deliver
  end
end
