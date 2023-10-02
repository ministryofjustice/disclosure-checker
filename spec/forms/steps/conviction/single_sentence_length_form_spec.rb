require "spec_helper"

RSpec.describe Steps::Conviction::SingleSentenceLengthForm do
  subject(:form) { described_class.new }

  it_behaves_like "a yes-no question form", attribute_name: :single_sentence_length
end
