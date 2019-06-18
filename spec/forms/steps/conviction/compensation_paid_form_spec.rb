require 'spec_helper'

RSpec.describe Steps::Conviction::CompensationPaidForm do
  it_behaves_like 'a yes-no question form', attribute_name: :compensation_paid
end
