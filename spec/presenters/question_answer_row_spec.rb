RSpec.describe QuestionAnswerRow do
  subject(:calculator) { described_class.new(question, answer, scope:, change_path:) }

  let(:question) { "question" }
  let(:answer) { "answer" }
  let(:scope) { %w[check_your_answers caution] }
  let(:change_path) { "/foo/bar" }

  describe "#to_partial_path" do
    it { expect(calculator.to_partial_path).to eq("check_your_answers/shared/row") }
  end

  describe "#question" do
    it { expect(calculator.question).to eq(question) }
  end

  describe "#answer" do
    it { expect(calculator.answer).to eq(answer) }
  end

  describe "#scope" do
    it { expect(calculator.scope).to eq(scope) }
  end

  describe "#change_path" do
    it { expect(calculator.change_path).to eq(change_path) }
  end

  describe "#show?" do
    context "when there is an answer" do
      it { expect(calculator.show?).to be(true) }
    end

    context "when answer is not present" do
      let(:answer) { "" }

      it { expect(calculator.show?).to be(false) }
    end
  end
end
