RSpec.describe CheckRow do
  let(:question) { 'question' }
  let(:answer) { 'answer' }
  let(:number) { 1 }
  let(:name) { 'name' }
  let(:question_answers) { 'question_rows' }
  subject { described_class.new(number, name, question_answers, scope: 'path/to/locales') }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/shared/check') }
  end

  describe '#number' do
    it { expect(subject.number).to eq(number) }
  end

  describe '#name' do
    it { expect(subject.name).to eq(name) }
  end

  describe '#question_answers' do
    it { expect(subject.question_answers).to eq(question_answers) }
  end
end
