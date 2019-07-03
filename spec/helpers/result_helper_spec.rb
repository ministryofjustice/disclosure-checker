require 'rails_helper'
RSpec.describe ResultHelper, type: :helper do
  describe '#title_string' do
    let(:past_title) { "Your #{kind} was spent on" }
    let(:present_title) { "Your #{kind} will be spent on" }

    context 'conviction' do
      let(:kind) { 'conviction' }
      it 'returns past tense title' do
        expect(helper.title_string(Date.yesterday, kind)).to include(past_title)
      end

      it 'returns present tense title' do
        expect(helper.title_string(Date.tomorrow, kind)).to include(present_title)
      end

       it 'returns never spent title' do
        expect(helper.title_string(nil, kind)).to include('never be spent')
      end
    end

    context 'caution' do
      let(:kind) { 'caution' }
      it 'returns past tense title' do
        expect(helper.title_string(Date.yesterday, kind)).to include(past_title)
      end

      it 'returns present tense title' do
        expect(helper.title_string(Date.tomorrow, kind)).to include(present_title)
      end

       it 'returns never spent title' do
        expect(helper.title_string(nil, kind)).to include('The caution date was not provided')
      end
    end
  end

  describe '#statement_string' do
    let(:statement) { "You do not need to tell anyone about this #{kind}" }
    let(:present_statement) { "After this date you will not need to tell anyone about this #{kind}" }

    context 'conviction' do
      let(:kind) { 'conviction' }
      it 'returns past tense title' do
        expect(helper.statement_string(Date.yesterday, kind)).to include(statement)
      end

      it 'returns present tense title' do
        expect(helper.statement_string(Date.tomorrow, kind)).to include(present_statement)
      end

      it 'returns never spent title' do
        expect(helper.statement_string(nil, kind)).to include('you will always have to tell people')
      end
    end

    context 'caution' do
      let(:kind) { 'caution' }
      it 'returns past tense title' do
        expect(helper.statement_string(Date.yesterday, kind)).to include(statement)
      end

      it 'returns present tense title' do
        expect(helper.statement_string(Date.tomorrow, kind)).to include(present_statement)
      end

      it 'returns never spent title' do
        expect(helper.statement_string(nil, kind)).to include(statement)
      end
    end
  end
end
