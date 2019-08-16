require 'rails_helper'

RSpec.describe BaseCalculator do
  subject { described_class.new(disclosure_check) }


   let(:disclosure_check) { build(:disclosure_check,
                                 known_date: known_date) }

  let(:known_date) { Date.new(2018, 10, 31) }

  before(:each) do
    described_class.send(:public, *described_class.private_instance_methods)
  end


  it 'distance_in_months' do
    expect(subject.distance_in_months(Date.new(2017, 8, 12), Date.new(2017, 8, 12))).to eq 0
    expect(subject.distance_in_months(Date.new(1993, 8, 8), Date.new(1993, 8, 8))).to eq 0
    expect(subject.distance_in_months(Date.new(2001, 12, 4), Date.new(2002, 3, 12))).to eq 3
    expect(subject.distance_in_months(Date.new(2001, 12, 4), Date.new(2002, 2, 12))).to eq 2
    expect(subject.distance_in_months(Date.new(2019, 1, 1), Date.new(2019, 1, 1))).to eq 0
    expect(subject.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 3, 23))).to eq 0
    expect(subject.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 5, 28))).to eq 2
    expect(subject.distance_in_months(Date.new(2004, 2, 29), Date.new(2004, 6, 13))).to eq 3
    expect(subject.distance_in_months(Date.new(2019, 7, 13), Date.new(2019, 9, 11))).to eq 1

    # Overlapping february (28 days) still counts Feb as a full month
    expect(subject.distance_in_months(Date.new(2017, 1, 1), Date.new(2017, 3, 31))).to eq 2
    expect(subject.distance_in_months(Date.new(2017, 2, 10), Date.new(2017, 3, 9))).to eq 0

    # Overlapping february (28 days) still counts Feb as a full month
    expect(subject.distance_in_months(Date.new(2019, 2, 28), Date.new(2020, 2, 29))).to eq 12

    # Should be 11 full months as 2020 is a leap year
    expect(subject.distance_in_months(Date.new(2020, 2, 29), Date.new(2021, 2, 28))).to eq 11

    # Leap year
    expect(subject.distance_in_months(Date.new(2016, 2, 1), Date.new(2016, 2, 29))).to eq 0
    expect(subject.distance_in_months(Date.new(2016, 2, 1), Date.new(2016, 3, 1))).to eq 1

    # Non leap year
    expect(subject.distance_in_months(Date.new(2017, 2, 1), Date.new(2017, 2, 28))).to eq 0
    expect(subject.distance_in_months(Date.new(2017, 2, 1), Date.new(2017, 3, 1))).to eq 1
  end


  context '#sentence_distance_in_months' do
    it 'in weeks' do
      expect(subject.sentence_length_in_months(4, 'weeks')).to be < 1
      expect(subject.sentence_length_in_months(5, 'weeks')).to be >= 1
      expect(subject.sentence_length_in_months(8, 'weeks')).to be < 2
      expect(subject.sentence_length_in_months(9, 'weeks')).to be >= 2

      # 3 months
      expect(subject.sentence_length_in_months(12, 'weeks')).to be < 3
      expect(subject.sentence_length_in_months(13, 'weeks')).to be >= 3

      # 6 months
      expect(subject.sentence_length_in_months(25, 'weeks')).to be < 6
      expect(subject.sentence_length_in_months(26, 'weeks')).to be >= 6


      # 25 months
      expect(subject.sentence_length_in_months(108, 'weeks')).to be < 25
      expect(subject.sentence_length_in_months(109, 'weeks')).to be >= 25

      # 30 months
      expect(subject.sentence_length_in_months(129, 'weeks')).to be < 30
      expect(subject.sentence_length_in_months(130, 'weeks')).to be >= 30
    end


    it 'in months' do
       # 3 months
      expect(subject.sentence_length_in_months(3, 'months')).to eq 3

      # 6 months
      expect(subject.sentence_length_in_months(6, 'months')).to eq 6

      # 25 months
     expect(subject.sentence_length_in_months(25, 'months')).to eq 25

      # 30 months
      expect(subject.sentence_length_in_months(30, 'months')).to eq 30
    end

    it 'in years' do
       # 1 year = 12 months
      expect(subject.sentence_length_in_months(1, 'years')).to eq 12

      # 2 years = 24 months
      expect(subject.sentence_length_in_months(2, 'years')).to eq 24

      # 10 years = 120 months
      expect(subject.sentence_length_in_months(10, 'years')).to eq 120

      # 25 years = 300 months
      expect(subject.sentence_length_in_months(25, 'years')).to eq 300
    end
  end
end
