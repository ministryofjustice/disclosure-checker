require 'spec_helper'

RSpec.describe Steps::Conviction::CompensationPaymentDateForm do
  it_behaves_like 'a date question form', attribute_name: :compensation_payment_date
end
