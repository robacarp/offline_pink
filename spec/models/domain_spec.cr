require "../spec_helper"

describe Domain do
  context "name" do
    dns_error_message = "Name should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"

    it "cannot be blank" do
      domain = Generate.domain! name: ""
      domain.errors.map(&.to_s).should contain "Name cannot be blank"
    end

    it "cant start with http" do
      domain = Generate.domain! name: "http://yolo"
      domain.errors.map(&.to_s).should contain dns_error_message
    end

    it "cant contain slashes" do
      domain = Generate.domain! name: "yolo/"
      domain.errors.map(&.to_s).should contain dns_error_message
    end

    it "cant be duplicated for the same user" do
      u = Generate.user!
      name = "example.com"
      domain1 = Generate.domain! name: name, user_id: u.id
      domain1.valid?.should be_true
      domain2 = Generate.domain! name: name, user_id: u.id
      domain2.valid?.should be_false
      domain2.errors.map(&.to_s).should contain "Name is already being checked"
    end
  end

  context "user_id" do
    it "must exist" do
      domain = Generate.domain! user_id: nil
      domain.valid?.should be_false
      domain.errors.map(&.to_s).should contain "User must be assigned"
    end

    it "is a user" do
      Generate.domain!.user.should be_a User
    end
  end

  context "status" do
    it "default status is unchecked" do
      domain = Generate.domain!
      domain.status.should eq Domain::Status::UnChecked
    end

    it "status= sets status_code" do
      domain = Generate.domain!
      domain.status = Domain::Status::Up
      domain.status_code.should eq Domain::Status::Up.to_i
    end

    it "enums are correct" do
      Domain::Status::UnChecked.to_i.should eq -1
      Domain::Status::Up.to_i.should eq 0
      Domain::Status::PartiallyDown.to_i.should eq 1
      Domain::Status::Down.to_i.should eq 2
    end
  end

  context "is_valid" do
    pending "can be set to true" do
    end

    pending "is the opposite of is_invalid" do
    end
  end

  context "old status methods" do
    context "up?" do
      pending "is true when all hosts are up?" do
      end
    end

    context "down?" do
      pending "is true when all hosts are down?" do
      end
    end

    context "partial_up?" do
      pending "is true when some hosts are up? and some are down?" do
      end
    end
  end

  context "monitors" do
    pending "returns all the monitors for this domain" do
    end
  end

  context "hosts" do
    pending "returns all the hosts for this domain" do
    end
  end

  context "monitor_results" do
    pending "returns all the monitor_results for this domain" do
    end
  end

  context "grouped_monitors" do
    pending "is a list of monitors grouped by type" do
    end
  end

  context "associations" do
    pending "are cascade destroyed" do
    end
  end

end
