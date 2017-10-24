require "rails_helper"

RSpec.describe ProfileAttributesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/profile_attributes").to route_to("profile_attributes#index")
    end

    it "routes to #new" do
      expect(:get => "/profile_attributes/new").to route_to("profile_attributes#new")
    end

    it "routes to #show" do
      expect(:get => "/profile_attributes/1").to route_to("profile_attributes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/profile_attributes/1/edit").to route_to("profile_attributes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/profile_attributes").to route_to("profile_attributes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/profile_attributes/1").to route_to("profile_attributes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/profile_attributes/1").to route_to("profile_attributes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/profile_attributes/1").to route_to("profile_attributes#destroy", :id => "1")
    end

  end
end
