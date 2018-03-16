require 'rails_helper'

RSpec.describe Support, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_embedded_in(:profile).as_inverse_of(:supports) }
end
