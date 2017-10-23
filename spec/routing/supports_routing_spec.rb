require "rails_helper"

RSpec.describe SupportsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/supports").to route_to("supports#index")
    end

    it "routes to #new" do
      expect(:get => "/supports/new").to route_to("supports#new")
    end

    it "routes to #show" do
      expect(:get => "/supports/1").to route_to("supports#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/supports/1/edit").to route_to("supports#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/supports").to route_to("supports#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/supports/1").to route_to("supports#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/supports/1").to route_to("supports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/supports/1").to route_to("supports#destroy", :id => "1")
    end

  end
end
