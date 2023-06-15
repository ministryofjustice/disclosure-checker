require "rails_helper"

RSpec.describe Steps::Caution::KnownDateController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Caution::KnownDateForm, CautionDecisionTree
end
