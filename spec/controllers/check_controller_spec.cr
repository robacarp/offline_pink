require "./spec_helper"

def create_subject
  subject = Check.new
  subject.type = "test"
  subject.save
  subject
end

describe CheckController do
  Spec.before_each do
    Check.clear
  end

  describe "index" do
    it "renders all the checks" do
      subject = create_subject
      get "/checks"
      response.body.should contain "test"
    end
  end

  describe "show" do
    it "renders a single check" do
      subject = create_subject
      get "/checks/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe "new" do
    it "render new template" do
      get "/checks/new"
      response.body.should contain "New Check"
    end
  end

  describe "create" do
    it "creates a check" do
      post "/checks", body: "type=testing"
      subject_list = Check.all
      subject_list.size.should eq 1
    end
  end

  describe "edit" do
    it "renders edit template" do
      subject = create_subject
      get "/checks/#{subject.id}/edit"
      response.body.should contain "Edit Check"
    end
  end

  describe "update" do
    it "updates a check" do
      subject = create_subject
      patch "/checks/#{subject.id}", body: "type=test2"
      result = Check.find(subject.id).not_nil!
      result.type.should eq "test2"
    end
  end

  describe "delete" do
    it "deletes a check" do
      subject = create_subject
      delete "/checks/#{subject.id}"
      result = Check.find subject.id
      result.should eq nil
    end
  end
end
