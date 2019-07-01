require 'rails_helper'
RSpec.describe ConvictionHelper, type: :helper do
  describe '#conviction_title_string' do
    it 'returns past tense title' do
      expect(helper.conviction_title_string(Date.yesterday)).to include('was spent on')
    end

    it 'returns present tense title' do
      expect(helper.conviction_title_string(Date.tomorrow)).to include('will be spent on')
    end

     it 'returns never spent title' do
      expect(helper.conviction_title_string(nil)).to include('never be spent')
    end
  end

  describe '#conviction_statement_string' do
    it 'returns past tense title' do
      expect(helper.conviction_statement_string(Date.yesterday)).to include('You do not need to tell anyone about this conviction')
    end

    it 'returns present tense title' do
      expect(helper.conviction_statement_string(Date.tomorrow)).to include('After this date you will not need to tell anyone')
    end

     it 'returns never spent title' do
      expect(helper.conviction_statement_string(nil)).to include(' you will always have to tell people')
    end
  end
end
