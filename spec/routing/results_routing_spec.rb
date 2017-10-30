require "rails_helper"

RSpec.describe ResultsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/results").to route_to("results#index")
    end

    it "routes to #new" do
      expect(:get => "/results/new").to route_to("results#new")
    end

    it "routes to #show" do
      expect(:get => "/results/1").to route_to("results#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/results/1/edit").to route_to("results#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/results").to route_to("results#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/results/1").to route_to("results#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/results/1").to route_to("results#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/results/1").to route_to("results#destroy", :id => "1")
    end

  end
end
