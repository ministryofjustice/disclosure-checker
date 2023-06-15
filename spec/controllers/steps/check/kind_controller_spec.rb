require "rails_helper"

RSpec.describe Steps::Check::KindController, type: :controller do
  it_behaves_like "a starting point step controller"
  it_behaves_like "an intermediate step controller", Steps::Check::KindForm, CheckDecisionTree
end
