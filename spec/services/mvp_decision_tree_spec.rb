require 'rails_helper'

RSpec.describe MvpDecisionTree do
  let(:step_params) { double('Step') }
  let(:next_step)   { nil }
  let(:as)          { nil }

  subject {
    described_class.new(
      disclosure_check: nil,
      step_params: step_params,
      as: as,
      next_step: next_step
    )
  }

  it_behaves_like 'a decision tree'

  context 'when the step is `info`' do
    let(:step_params) { { info: 'whatever' } }
    it { is_expected.to have_destination(:confirmation, :show) }
  end
end
