require "rails_helper"

RSpec.describe ReposController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/repos").to route_to("repos#index")
    end

    it "routes to #new" do
      expect(:get => "/repos/new").to route_to("repos#new")
    end

    it "routes to #show" do
      expect(:get => "/repos/1").to route_to("repos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/repos/1/edit").to route_to("repos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/repos").to route_to("repos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/repos/1").to route_to("repos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/repos/1").to route_to("repos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/repos/1").to route_to("repos#destroy", :id => "1")
    end

  end
end
