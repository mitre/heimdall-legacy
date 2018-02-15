require "rails_helper"

RSpec.describe RepoCredsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/repo_creds").to route_to("repo_creds#index")
    end

    it "routes to #new" do
      expect(:get => "/repo_creds/new").to route_to("repo_creds#new")
    end

    it "routes to #show" do
      expect(:get => "/repo_creds/1").to route_to("repo_creds#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/repo_creds/1/edit").to route_to("repo_creds#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/repo_creds").to route_to("repo_creds#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/repo_creds/1").to route_to("repo_creds#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/repo_creds/1").to route_to("repo_creds#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/repo_creds/1").to route_to("repo_creds#destroy", :id => "1")
    end

  end
end
