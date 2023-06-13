require "rails_helper"

RSpec.describe Steps::Conviction::CompensationPaymentDateController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::CompensationPaymentDateForm, ConvictionDecisionTree
end
