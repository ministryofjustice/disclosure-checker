require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionMultipleSentencesForm do
  it_behaves_like "a yes-no question form", attribute_name: :conviction_multiple_sentences
end
