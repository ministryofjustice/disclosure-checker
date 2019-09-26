require 'rails_helper'

RSpec.describe Steps::Conviction::MotoringDisqualificationEndDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::MotoringDisqualificationEndDateForm, ConvictionDecisionTree
end
