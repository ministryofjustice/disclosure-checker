require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionLengthController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionLengthForm, ConvictionDecisionTree
end
