class Domains::Verification::ShowPage < AuthLayout
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text domain.status_code.to_s.downcase
        end

        div do
        end
      end

      case domain.verification_status
      when Domain::Verification::UnChecked
        domain_verification_instructions
        unchecked_domain_verification
      when Domain::Verification::Pending
        domain_verification_instructions
        pending_domain_verification
      when Domain::Verification::Verified
        verified_domain
      when Domain::Verification::Invalid
        domain_verification_instructions
        invalid_domain_verification
      end
    end
  end

  def pending_domain_verification
    para "We're still checking the validity of this domain."
  end

  def domain_verification_instructions
    div class: "flash w-full border p-4 rounded bg-red-100 border-red-400 text-red-700" do
      para "Please add the following TXT record to your DNS configuration:"
      div class: "" do
        text "#{domain.verification_token}.#{domain.name} TXT offline.pink verified"
      end
    end
  end

  def unchecked_domain_verification
    text "when you've added the TXT record, "
    form_for Domains::Verification::Create.with(domain) do
      submit "press this button"
    end
  end

  def pending_domain_verification
    text "pending domain verification"
  end

  def invalid_domain_verification
    text "invalid domain verification"
  end

  def check_verification_now_button
    text "re-check verification now"
  end

  def verified_domain
    text "domain is verified"
  end
end
