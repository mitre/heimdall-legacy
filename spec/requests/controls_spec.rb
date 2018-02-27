require 'rails_helper'

RSpec.describe "Controls", type: :request do

  describe "GET /controls" do
    it "works! (now write some real specs)" do
      control = create :control
      get profile_control_path(control.profile_id, control)
      expect(response).to have_http_status(200)
    end
  end
end
