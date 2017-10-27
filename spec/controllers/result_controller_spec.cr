require "./spec_helper"

def create_subject
  subject = Result.new
  subject.is_up = "test"
  subject.save
  subject
end

describe ResultController do
  Spec.before_each do
    Result.clear
  end

  describe "index" do
    it "renders all the results" do
      subject = create_subject
      get "/results"
      response.body.should contain "test"
    end
  end

  describe "show" do
    it "renders a single result" do
      subject = create_subject
      get "/results/#{subject.id}"
      response.body.should contain "test"
    end
  end

  describe "new" do
    it "render new template" do
      get "/results/new"
      response.body.should contain "New Result"
    end
  end

  describe "create" do
    it "creates a result" do
      post "/results", body: "is_up=testing"
      subject_list = Result.all
      subject_list.size.should eq 1
    end
  end

  describe "edit" do
    it "renders edit template" do
      subject = create_subject
      get "/results/#{subject.id}/edit"
      response.body.should contain "Edit Result"
    end
  end

  describe "update" do
    it "updates a result" do
      subject = create_subject
      patch "/results/#{subject.id}", body: "is_up=test2"
      result = Result.find(subject.id).not_nil!
      result.is_up.should eq "test2"
    end
  end

  describe "delete" do
    it "deletes a result" do
      subject = create_subject
      delete "/results/#{subject.id}"
      result = Result.find subject.id
      result.should eq nil
    end
  end
end
