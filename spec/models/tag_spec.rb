require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_embedded_in(:control).as_inverse_of(:tags) }
end
