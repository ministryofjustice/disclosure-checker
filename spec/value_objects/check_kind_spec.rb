require "rails_helper"

RSpec.describe CheckKind do
  describe ".values" do
    it "returns all possible values" do
      expect(described_class.values.map(&:to_s)).to eq(%w[
        caution
        conviction
      ])
    end
  end
end
