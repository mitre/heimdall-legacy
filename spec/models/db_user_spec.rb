require 'rails_helper'

RSpec.describe DbUser, type: :model do
  it { is_expected.to be_mongoid_document }
end
