require 'spec_helper'

RSpec.describe Steps::Caution::ConditionalEndDateForm do
  it_behaves_like 'a date question form', attribute_name: :conditional_end_date, future_date: true
end
