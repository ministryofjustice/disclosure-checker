require 'rails_helper'

RSpec.describe Steps::Conviction::MotoringLifetimeBanController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::MotoringLifetimeBanForm, ConvictionDecisionTree
end
