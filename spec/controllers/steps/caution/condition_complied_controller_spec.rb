require 'rails_helper'

RSpec.describe Steps::Caution::ConditionCompliedController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Caution::ConditionCompliedForm, CautionDecisionTree
end
