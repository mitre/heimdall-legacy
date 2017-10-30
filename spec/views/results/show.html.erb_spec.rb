require 'rails_helper'

RSpec.describe "results/show", type: :view do
  before(:each) do
    @result = assign(:result, Result.create!(
      :status => "Status",
      :code_desc => "Code Desc",
      :skip_message => "Skip Message",
      :resource => "Resource",
      :run_time => 2.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Code Desc/)
    expect(rendered).to match(/Skip Message/)
    expect(rendered).to match(/Resource/)
    expect(rendered).to match(/2.5/)
  end
end
