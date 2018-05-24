require 'rails_helper'

RSpec.describe FilterGroup, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_and_belong_to_many(:filters).of_type(Filter) }
end
