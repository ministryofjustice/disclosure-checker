require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionLengthTypeController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionLengthTypeForm, ConvictionDecisionTree
end
