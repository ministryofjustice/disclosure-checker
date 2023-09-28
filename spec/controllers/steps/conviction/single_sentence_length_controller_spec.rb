require 'rails_helper'

RSpec.describe Steps::Conviction::SingleSentenceLengthController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::SingleSentenceLengthForm, ConvictionDecisionTree
end
