require "rails_helper"

RSpec.describe Steps::Conviction::ConvictionBailDaysController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::ConvictionBailDaysForm, ConvictionDecisionTree
end
