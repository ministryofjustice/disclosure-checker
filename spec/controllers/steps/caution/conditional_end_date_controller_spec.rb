require "rails_helper"

RSpec.describe Steps::Caution::ConditionalEndDateController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Caution::ConditionalEndDateForm, CautionDecisionTree
end
