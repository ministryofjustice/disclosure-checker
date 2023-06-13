require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionSubtypeController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionSubtypeForm, ConvictionDecisionTree
end
