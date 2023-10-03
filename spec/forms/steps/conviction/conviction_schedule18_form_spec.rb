require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionSchedule18Form do
  subject(:form) { described_class.new }

  it_behaves_like "a yes-no question form", attribute_name: :conviction_schedule18

  describe "#i18n_attribute" do
    it "returns the key that will be used to translate legends and hints" do
      expect(form.i18n_attribute).to eq("conviction_schedule18_text")
    end
  end
end
