require "spec_helper"

RSpec.describe Steps::Conviction::SingleSentenceOver4Form do
  subject(:form) { described_class.new }

  it_behaves_like "a yes-no question form", attribute_name: :single_sentence_over4
end
