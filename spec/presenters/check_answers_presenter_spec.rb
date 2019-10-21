RSpec.describe CheckAnswersPresenter do
  let!(:disclosure_check) { create(:disclosure_check) }
  let!(:disclosure_report) { disclosure_check.disclosure_report }

  subject { described_class.new(disclosure_report) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/check') }
  end

  describe '#summary' do
    let(:summary) { subject.summary }
    context 'for a single youth caution' do
      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(1)

        expect(summary[0].number).to eql(1)
        expect(summary[0].name).to eql('caution')

        question_answers = summary[0].question_answers
        expect(question_answers.size).to eq(4)

        expect(question_answers[0].question).to eql(:kind)
        expect(question_answers[0].answer).to eql('caution')

        expect(question_answers[1].question).to eql(:caution_type)
        expect(question_answers[1].answer).to eql('youth_simple_caution')

        expect(question_answers[2].question).to eql(:under_age)
        expect(question_answers[2].answer).to eql('yes')

        expect(question_answers[3].question).to eql(:known_date)
        expect(question_answers[3].answer).to eq('31 October 2018')
      end
    end
  end
end
