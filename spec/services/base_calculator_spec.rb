require 'rails_helper'

RSpec.describe BaseCalculator do
  subject { described_class.new(disclosure_check) }


   let(:disclosure_check) { build(:disclosure_check,
                                 known_date: known_date) }

  let(:known_date) { Date.new(2018, 10, 31) }

  before(:each) do
    described_class.send(:public, *described_class.private_instance_methods)
  end


  it 'length_in_months' do
    expect(subject.length_in_months(Date.new(2017, 8, 12), Date.new(2017, 8, 12))).to eq 0
    expect(subject.length_in_months(Date.new(1993, 8, 8), Date.new(1993, 8, 8))).to eq 0
    expect(subject.length_in_months(Date.new(2001, 12, 4), Date.new(2002, 3, 12))).to eq 3
    expect(subject.length_in_months(Date.new(2001, 12, 4), Date.new(2002, 2, 12))).to eq 2
    expect(subject.length_in_months(Date.new(2019, 1, 1), Date.new(2019, 1, 1))).to eq 0
    expect(subject.length_in_months(Date.new(2004, 2, 29), Date.new(2004, 3, 23))).to eq 0
    expect(subject.length_in_months(Date.new(2004, 2, 29), Date.new(2004, 5, 28))).to eq 2
    expect(subject.length_in_months(Date.new(2004, 2, 29), Date.new(2004, 6, 13))).to eq 3
    expect(subject.length_in_months(Date.new(2019, 7, 13), Date.new(2019, 9, 11))).to eq 1

    # Overlapping february (28 days) still counts Feb as a full month
    expect(subject.length_in_months(Date.new(2017, 1, 1), Date.new(2017, 3, 31))).to eq 2
    expect(subject.length_in_months(Date.new(2017, 2, 10), Date.new(2017, 3, 9))).to eq 0

    # Overlapping february (28 days) still counts Feb as a full month
    expect(subject.length_in_months(Date.new(2019, 2, 28), Date.new(2020, 2, 29))).to eq 12

    # Should be 11 full months as 2020 is a leap year
    expect(subject.length_in_months(Date.new(2020, 2, 29), Date.new(2021, 2, 28))).to eq 11

    # Leap year
    expect(subject.length_in_months(Date.new(2016, 2, 1), Date.new(2016, 2, 29))).to eq 0
    expect(subject.length_in_months(Date.new(2016, 2, 1), Date.new(2016, 3, 1))).to eq 1

    # Non leap year
    expect(subject.length_in_months(Date.new(2017, 2, 1), Date.new(2017, 2, 28))).to eq 0
    expect(subject.length_in_months(Date.new(2017, 2, 1), Date.new(2017, 3, 1))).to eq 1
  end
end
