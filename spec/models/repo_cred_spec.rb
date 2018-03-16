require 'rails_helper'

RSpec.describe RepoCred, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_embedded_in(:repo).as_inverse_of(:repo_creds) }
end
