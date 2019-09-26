require 'spec_helper'

RSpec.describe Steps::Conviction::MotoringEndorsementForm do
  it_behaves_like 'a yes-no question form', attribute_name: :motoring_endorsement
end
