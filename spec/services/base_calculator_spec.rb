require "rails_helper"

RSpec.describe BaseCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, known_date:) }
  let(:known_date) { Date.new(2018, 10, 31) }

  before do
    described_class.send(:public, *described_class.private_instance_methods)
  end

  it "distance_in_months" do
    expect(calculator.distance_in_months(Date.new(2017, 8, 12), Date.new(2017, 8, 12))).to eq 0
    expect(calculator.distance_in_months(Date.new(1993, 8, 8), Date.new(1993, 8, 8))).to eq 0
    expect(calculator.distance_in_months(Date.new(2001, 12, 4), Date.new(2002, 3, 12))).to eq 3
    expect(calculator.distance_in_months(Date.new(2001, 12, 4), Date.new(2002, 2, 12))).to eq 2
    expect(calculator.distance_in_months(Date.new(2019, 1, 1), Date.new(2019, 1, 1))).to eq 0
    expect(calculator.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 3, 23))).to eq 0
    expect(calculator.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 5, 28))).to eq 2
    expect(calculator.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 6, 13))).to eq 3
    expect(calculator.distance_in_months(Date.new(2019, 7, 13), Date.new(2019, 9, 11))).to eq 1

    # Overlapping february (28 days) still counts Feb as a full month
    expect(calculator.distance_in_months(Date.new(2017, 1, 1), Date.new(2017, 3, 31))).to eq 2
    expect(calculator.distance_in_months(Date.new(2017, 2, 10), Date.new(2017, 3, 9))).to eq 0

    # Overlapping february (28 days) still counts Feb as a full month
    expect(calculator.distance_in_months(Date.new(2019, 2, 28), Date.new(2020, 2, 29))).to eq 12

    # Should be 11 full months as 2020 is a leap year
    expect(calculator.distance_in_months(Date.new(2020, 2, 29), Date.new(2021, 2, 28))).to eq 11

    # Leap year
    expect(calculator.distance_in_months(Date.new(2016, 2, 1), Date.new(2016, 2, 29))).to eq 0
    expect(calculator.distance_in_months(Date.new(2016, 2, 1), Date.new(2016, 3, 1))).to eq 1

    # Non leap year
    expect(calculator.distance_in_months(Date.new(2017, 2, 1), Date.new(2017, 2, 28))).to eq 0
    expect(calculator.distance_in_months(Date.new(2017, 2, 1), Date.new(2017, 3, 1))).to eq 1
  end

  describe "#sentence_distance_in_months" do
    it "in days" do
      expect(calculator.sentence_length_in_months(30, "days")).to be < 1
      expect(calculator.sentence_length_in_months(31, "days")).to be >= 1

      # 2 months
      expect(calculator.sentence_length_in_months(60, "days")).to be < 2
      expect(calculator.sentence_length_in_months(61, "days")).to be >= 2

      # 3 months
      expect(calculator.sentence_length_in_months(91, "days")).to be < 3
      expect(calculator.sentence_length_in_months(92, "days")).to be >= 3

      # 6 months
      expect(calculator.sentence_length_in_months(182, "days")).to be < 6
      expect(calculator.sentence_length_in_months(183, "days")).to be >= 6

      # 25 months
      expect(calculator.sentence_length_in_months(760, "days")).to be < 25
      expect(calculator.sentence_length_in_months(761, "days")).to be >= 25

      # 30 months
      expect(calculator.sentence_length_in_months(913, "days")).to be < 30
      expect(calculator.sentence_length_in_months(914, "days")).to be >= 30
    end

    it "in weeks" do
      expect(calculator.sentence_length_in_months(4, "weeks")).to be < 1
      expect(calculator.sentence_length_in_months(5, "weeks")).to be >= 1

      # 2 months
      expect(calculator.sentence_length_in_months(8, "weeks")).to be < 2
      expect(calculator.sentence_length_in_months(9, "weeks")).to be >= 2

      # 3 months
      expect(calculator.sentence_length_in_months(13, "weeks")).to be < 3
      expect(calculator.sentence_length_in_months(14, "weeks")).to be >= 3

      # 6 months
      expect(calculator.sentence_length_in_months(26, "weeks")).to be < 6
      expect(calculator.sentence_length_in_months(27, "weeks")).to be >= 6

      # 25 months
      expect(calculator.sentence_length_in_months(108, "weeks")).to be < 25
      expect(calculator.sentence_length_in_months(109, "weeks")).to be >= 25

      # 30 months
      expect(calculator.sentence_length_in_months(130, "weeks")).to be < 30
      expect(calculator.sentence_length_in_months(131, "weeks")).to be >= 30
    end

    it "in months" do
      # 3 months
      expect(calculator.sentence_length_in_months(3, "months")).to eq 3

      # 6 months
      expect(calculator.sentence_length_in_months(6, "months")).to eq 6

      # 25 months
      expect(calculator.sentence_length_in_months(25, "months")).to eq 25

      # 30 months
      expect(calculator.sentence_length_in_months(30, "months")).to eq 30
    end

    it "in years" do
      # 1 year = 12 months
      expect(calculator.sentence_length_in_months(1, "years")).to eq 12

      # 2 years = 24 months
      expect(calculator.sentence_length_in_months(2, "years")).to eq 24

      # 10 years = 120 months
      expect(calculator.sentence_length_in_months(10, "years")).to eq 120

      # 25 years = 300 months
      expect(calculator.sentence_length_in_months(25, "years")).to eq 300
    end
  end
end
