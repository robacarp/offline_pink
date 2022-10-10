class Domains::Verification::ShowPage < AuthLayout
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text "ownership verification"
        end
      end

      case domain.verification_status
      when Domain::Verification::UnChecked
        domain_verification_instructions
      when Domain::Verification::Pending
        pending_verification
        domain_verification_instructions
      when Domain::Verification::Verified
        verified_domain
      when Domain::Verification::Failed
        invalid_verification
        domain_verification_instructions
      end
    end
  end

  def pending_verification
    mount Shared::AlertBox, dismissable: false do
      para "#{domain.name} is queued for DNS verification."
    end
  end

  def domain_verification_instructions
    para "To verify your domain, please add the following DNS record to your domain's name servers:"
    div class: "font-mono bg-gray-500 flex space-x-8 p-4 my-4" do
      div "TXT"
      div "#{domain.verification_token}.#{domain.name}."
      div "\"offline.pink verified\""
    end

    hr

    div class: "flex justify-center w-full mt-4" do
      form_for Domains::Verification::Create.with(domain) do
        submit "I've added the record, please check now"
      end
    end
  end

  def invalid_verification
    mount Shared::AlertBox, severity: "failure", dismissable: false do
      para "#{domain.name} did not complete verification. We looked #{time_ago_in_words(domain.verification_date)} ago."
    end
  end

  def verified_domain
    mount Shared::AlertBox, dismissable: false do
      para "#{domain.name} is verified!"
    end
  end
end
