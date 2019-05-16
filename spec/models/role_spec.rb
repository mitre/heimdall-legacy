require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_and_belong_to_many(:users).of_type(User) }
end
