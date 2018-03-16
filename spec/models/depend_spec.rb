require 'rails_helper'

RSpec.describe Depend, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  it { is_expected.to be_embedded_in(:profile).as_inverse_of(:depends) }
end
