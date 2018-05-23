require 'rails_helper'

RSpec.describe 'evaluations/show', type: :view do
  before(:each) do
    @evaluation = assign(
      :evaluation,
      Evaluation.create!(
        version:             'Version',
        other_checks:        ['Other Checks'],
        platform_name:       'Platform Name',
        platform_release:    'Platform Release',
        statistics_duration: 'Statistics Duration',
      ),
    )
    @counts, @controls = @evaluation.status_counts
    @nist_hash = Constants::NIST_800_53
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/Version/)
    expect(rendered).to match(/Other Checks/)
    expect(rendered).to match(/Platform Name/)
    expect(rendered).to match(/Platform Release/)
    expect(rendered).to match(/Statistics Duration/)
  end
end
