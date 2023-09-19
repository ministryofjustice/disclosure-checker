require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionSchedule18Form do
  it_behaves_like 'a yes-no question form', attribute_name: :conviction_schedule18
end
