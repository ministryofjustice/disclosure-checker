require "rails_helper"

RSpec.describe Steps::Caution::CautionTypeController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Caution::CautionTypeForm, CautionDecisionTree
end
