require 'rails_helper'

RSpec.describe "results/show", type: :view do
  before(:each) do
    @result = create :result
    @evaluation = @result.evaluation
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Resource/)
  end
end
