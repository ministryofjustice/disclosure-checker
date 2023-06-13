require "rails_helper"

RSpec.describe Steps::Conviction::MotoringEndorsementController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::MotoringEndorsementForm, ConvictionDecisionTree
end
