require "spec_helper"

RSpec.describe Steps::Conviction::SingleSentenceLengthForm do
  subject(:form) { described_class.new }

  it_behaves_like "a yes-no question form", attribute_name: :single_sentence_length

  describe "#i18n_attribute" do
    it "returns the key that will be used to translate legends and hints" do
      expect(form.i18n_attribute).to eq("single_sentence_length_text")
    end
  end
end
