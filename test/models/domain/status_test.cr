require "../../test_helper"

describe "Domain#user_id" do
  it "default status is unchecked" do
    domain = Generate.domain
    assert_equal Domain::Status::UnChecked, domain.status
  end

  it "status= sets status_code" do
    domain = Generate.domain
    domain.status = Domain::Status::Up
    assert_equal Domain::Status::Up.to_i, domain.status_code
  end

  it "enums are correct" do
    assert_equal -1, Domain::Status::UnChecked.to_i
    assert_equal 0, Domain::Status::Up.to_i
    assert_equal 1, Domain::Status::PartiallyDown.to_i
    assert_equal 2, Domain::Status::Down.to_i
  end
end
