require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'category_button' do
    it 'gets a button from an impact' do
      expect(helper.category_button(0.2)).to eq('btn btn-category-iii')
      expect(helper.category_button(0.5)).to eq('btn btn-category-ii')
      expect(helper.category_button(0.8)).to eq('btn btn-category-i')
    end
  end

  describe 'status_label' do
    it 'converts a symbol into a label' do
      expect(helper.status_label(:not_applicable)).to eq('Not Applicable')
    end
  end

  describe 'status_btn' do
    it 'gets a button from a symbol' do
      expect(helper.status_btn(:not_applicable)).to eq('btn btn-info')
      expect(helper.status_btn(:open)).to eq('btn btn-danger')
      expect(helper.status_btn(:not_a_finding)).to eq('btn btn-success')
      expect(helper.status_btn(:not_reviewed)).to eq('btn btn-neutral')
      expect(helper.status_btn(nil)).to eq('btn btn-neutral')
    end
  end

  describe 'result_message' do
    it 'converts a symbol into a message' do
      expect(helper.result_message(:not_applicable)).to be_a(String)
      expect(helper.result_message(:open)).to be_a(String)
      expect(helper.result_message(:not_a_finding)).to be_a(String)
      expect(helper.result_message(:not_reviewed)).to be_a(String)
      expect(helper.result_message(nil)).to be_a(String)
    end
  end

  describe 'ary_to_s' do
    it 'converts an array to a string' do
      expect(helper.ary_to_s(['"value"'])).to eq('value')
    end
  end

  describe 'icon' do
    it 'get as css label for a class' do
      expect(helper.icon(Evaluation)).to eq('ion-pie-graph')
      expect(helper.icon(Profile)).to eq('ion-ios-folder')
      expect(helper.icon(User)).to eq('ion-person-add')
    end
  end

  describe 'flash_class' do
    it 'get as css label for a flash message' do
      expect(helper.flash_class('notice')).to eq('alert alert-info')
      expect(helper.flash_class('success')).to eq('alert alert-success')
      expect(helper.flash_class('error')).to eq('alert alert-error')
      expect(helper.flash_class('alert')).to eq('alert alert-error')
    end
  end

  context 'with findings' do
    let(:findings) { { not_a_finding: 23, open: 43, not_reviewed: 23, not_tested: 10, not_applicable: 18 } }

    describe 'pass_pixels' do
      it 'converts an array to a string' do
        expect(helper.pass_pixels(findings)).to eq(46)
      end
    end

    describe 'fail_pixels' do
      it 'converts an array to a string' do
        expect(helper.fail_pixels(findings)).to eq(154)
      end
    end

    describe 'compliance' do
      it 'converts an array to a string' do
        expect(helper.compliance(findings)).to eq(23.23)
      end
    end
  end
end
