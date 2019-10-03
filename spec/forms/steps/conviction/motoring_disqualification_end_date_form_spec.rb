require 'spec_helper'

RSpec.describe Steps::Conviction::MotoringDisqualificationEndDateForm do
  it_behaves_like 'a date question form', attribute_name: :motoring_disqualification_end_date, allow_empty_date: true, allow_future: true
end
