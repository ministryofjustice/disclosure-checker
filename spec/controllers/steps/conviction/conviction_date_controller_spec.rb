require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionDateController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionDateForm, ConvictionDecisionTree
end
