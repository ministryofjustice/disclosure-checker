RSpec.describe QuestionAnswerRow do
  let(:question) { 'question' }
  let(:answer) { 'answer' }
  let(:scope) { %w(check_your_answers caution) }
  let(:change_path) { '/foo/bar' }

  subject { described_class.new(question, answer, scope: scope, change_path: change_path) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/shared/row') }
  end

  describe '#question' do
    it { expect(subject.question).to eq(question) }
  end

  describe '#answer' do
    it { expect(subject.answer).to eq(answer) }
  end

  describe '#scope' do
    it { expect(subject.scope).to eq(scope) }
  end

  describe '#change_path' do
    it { expect(subject.change_path).to eq(change_path) }
  end

  describe '#show?' do
    context 'when there is an answer' do
      it { expect(subject.show?).to eq(true) }
    end

    context 'when answer is not present' do
      let(:answer) { '' }
      it { expect(subject.show?).to eq(false) }
    end
  end
end
