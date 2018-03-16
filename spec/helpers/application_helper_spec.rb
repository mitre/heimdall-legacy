require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "category_button" do
    it "gets a button from an impact" do
      expect(helper.category_button(0.2)).to eq("btn btn-category-iii")
      expect(helper.category_button(0.5)).to eq("btn btn-category-ii")
      expect(helper.category_button(0.8)).to eq("btn btn-category-i")
    end
  end

  describe "status_label" do
    it "converts a symbol into a label" do
      expect(helper.status_label(:not_applicable)).to eq("Not Applicable")
    end
  end

  describe "status_btn" do
    it "gets a button from a symbol" do
      expect(helper.status_btn(:not_applicable)).to eq("btn btn-info")
      expect(helper.status_btn(:open)).to eq("btn btn-danger")
      expect(helper.status_btn(:not_a_finding)).to eq("btn btn-success")
      expect(helper.status_btn(:not_reviewed)).to eq("btn btn-neutral")
      expect(helper.status_btn(nil)).to eq("btn btn-neutral")
    end
  end

  describe "result_message" do
    it "converts a symbol into a message" do
      expect(helper.result_message(:not_applicable)).to be_a(String)
      expect(helper.result_message(:open)).to be_a(String)
      expect(helper.result_message(:not_a_finding)).to be_a(String)
      expect(helper.result_message(:not_reviewed)).to be_a(String)
      expect(helper.result_message(nil)).to be_a(String)
    end
  end

end
