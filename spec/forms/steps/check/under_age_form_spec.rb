require "spec_helper"

RSpec.describe Steps::Check::UnderAgeForm do
  it_behaves_like "a yes-no question form", attribute_name: :under_age

  describe "#i18n_attribute" do
    let(:disclosure_check) { DisclosureCheck.new(kind: "conviction") }

    before do
      form.disclosure_check = disclosure_check
    end

    it "returns the key that will be used to translate legends and hints" do
      expect(form.i18n_attribute).to eq("conviction")
    end
  end
end
