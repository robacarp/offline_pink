require "../spec_helper"

describe User do
  context "validations" do
    context "email" do
      it "cannot be blank" do
        user = User.new email: ""
        user.valid?.should be_false
        errors = user.errors.select { |err| err.field == :email }
        errors.size.should eq 1
        errors.first.message.should eq "cannot be blank"
      end

      it "cannot be duplicated" do
        email = "user@example.com"
        existing_user = Generate.user! email: email
        existing_user.new_record?.should be_false

        user = Generate.user email: email
        user.valid?.should be_false
        user.errors.map(&.to_s).should contain("Email is already registered")
      end
    end

    context "password_hash" do
      it "cannot be blank" do
        u = Generate.user
        u.crypted_password = nil
        u.valid?.should be_false
        u.errors.map(&.to_s).should contain("Password cannot be blank")
      end
    end
  end

  context "password" do
    it "can be compared" do
      u = Generate.user! password: "12345"
      u.check_password("2468").should be_false
      u.check_password("12345").should be_true
    end
  end

  context "pushover key" do
    it "returns a key when it is available" do
      user = Generate.user!
      key = Generate.pushover_key! user_id: user.id
      User.find!(user.id).pushover_key.new_record?.should be_false
    end

    it "creates a new key object when no key exists" do
      Generate.user!.pushover_key.new_record?.should be_true
    end
  end

  context "guest user" do
    it "is not a registered user" do
      User.guest_user.guest?.should be_true
    end

    it "a registered user is not a guest" do
      Generate.user!.guest?.should be_false
    end
  end
end
