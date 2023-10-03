require "rails_helper"

RSpec.describe Steps::Conviction::SingleSentenceOver4Controller, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Conviction::SingleSentenceOver4Form, ConvictionDecisionTree
end
