require "rails_helper"

RSpec.describe Steps::Conviction::KnownDateController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::KnownDateForm, ConvictionDecisionTree
end
