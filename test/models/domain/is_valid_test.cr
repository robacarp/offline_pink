require "../../test_helper"

describe "Domain#is_valid?" do
  it "can be set to true" do
    domain = Generate.domain is_valid: true
    assert domain.is_valid?

    domain = Generate.domain is_valid: false
    refute domain.is_valid?
  end

  it "is the opposite of is_invalid" do
    domain = Generate.domain is_valid: true
    refute domain.is_invalid?
  end
end
