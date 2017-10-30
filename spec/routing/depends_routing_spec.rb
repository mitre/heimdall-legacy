require "rails_helper"

RSpec.describe DependsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/depends").to route_to("depends#index")
    end

    it "routes to #new" do
      expect(:get => "/depends/new").to route_to("depends#new")
    end

    it "routes to #show" do
      expect(:get => "/depends/1").to route_to("depends#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/depends/1/edit").to route_to("depends#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/depends").to route_to("depends#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/depends/1").to route_to("depends#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/depends/1").to route_to("depends#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/depends/1").to route_to("depends#destroy", :id => "1")
    end

  end
end
