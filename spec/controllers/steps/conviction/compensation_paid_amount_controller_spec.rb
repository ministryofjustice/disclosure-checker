require 'rails_helper'

RSpec.describe Steps::Conviction::CompensationPaidAmountController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::CompensationPaidAmountForm, ConvictionDecisionTree
end
