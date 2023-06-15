require "rails_helper"

RSpec.describe Steps::Check::UnderAgeController, type: :controller do
  it_behaves_like "an intermediate step controller", Steps::Check::UnderAgeForm, CheckDecisionTree
end
