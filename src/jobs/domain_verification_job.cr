class DomainVerificationJob < Mosquito::QueuedJob
  params(domain_id : Int64)

  #  PoorDNS responds with the raw Bind9 style zone record:
  #  "example.com.\t\t900\tIN\tTXT\t\"v=spf1 include:spf.messagingengine.com ~all\""]
  #  "bFUB93-js5rJ-jNupa9NemZV.robacarp.com. 78 IN TXT \"offline.pink verified\""

  def perform
    domain = DomainQuery.new.find domain_id
    fqdn = domain.verification_token + "." + domain.name
    txt_records = PoorDNS.query fqdn, "TXT"
    
    log "Found TXT records #{txt_records}"

    save = DomainOp::UpdateVerification.new(domain)

    if txt_records.any?(&.matches? /offline.pink verified/)
      log "#{fqdn} verified"
      save.verification_status.value = Domain::Verification::Verified
    else
      log "#{fqdn} not verified"
      save.verification_status.value = Domain::Verification::Invalid
    end

    save.save!
  end
end
