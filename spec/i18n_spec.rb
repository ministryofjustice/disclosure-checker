require "i18n/tasks"
require "rails_helper"

RSpec.describe "I18n" do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:missing_keys) { i18n.missing_keys }

  it "does not have missing keys" do
    expect(missing_keys).to be_empty,
                            "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"
  end

  # NOTE: The following sanity checks will ensure we have the same keys and values in both places,
  # so we don't inadvertently update just one place but not the other.
  # It doesn't matter the order of the keys in the locales, what matters is the content.
  #
  context "shared dictionaries sanity checks" do
    it "caution types in `helpers.yml` match caution types in `results.yml`" do
      expect(
        i18n.tree("en.helpers/dictionary.CAUTION_TYPES").to_hash,
      ).to eq(
        i18n.tree("en.results/dictionary.CAUTION_TYPES").to_hash,
      )
    end

    it "convictions subtypes in `helpers.yml` match convictions subtypes in `results.yml`" do
      expect(
        i18n.tree("en.helpers/dictionary.CONVICTION_SUBTYPES").to_hash,
      ).to eq(
        i18n.tree("en.results/dictionary.CONVICTION_SUBTYPES").to_hash,
      )
    end
  end
end
