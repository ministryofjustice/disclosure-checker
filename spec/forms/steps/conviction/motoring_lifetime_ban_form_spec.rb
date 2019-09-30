require 'spec_helper'

RSpec.describe Steps::Conviction::MotoringLifetimeBanForm do
  it_behaves_like 'a yes-no question form', attribute_name: :motoring_lifetime_ban
end
