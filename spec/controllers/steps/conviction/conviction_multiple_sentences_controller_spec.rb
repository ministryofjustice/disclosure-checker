require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionSchedule18Controller, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionMultipleSentencesForm, ConvictionDecisionTree
end
