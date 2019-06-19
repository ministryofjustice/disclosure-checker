require 'spec_helper'

RSpec.describe Steps::Conviction::KnownDateForm do
  it_behaves_like 'a date question form', attribute_name: :known_date
end
