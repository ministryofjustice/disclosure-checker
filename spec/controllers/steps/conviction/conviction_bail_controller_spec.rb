require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionBailController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionBailForm, ConvictionDecisionTree
end
