require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionTypeController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionTypeForm, ConvictionDecisionTree
end
