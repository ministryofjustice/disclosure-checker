require 'rails_helper'

RSpec.describe Steps::Conviction::CompensationPaidController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::CompensationPaidForm, ConvictionDecisionTree
end
