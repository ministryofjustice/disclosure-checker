require 'spec_helper'

RSpec.describe Steps::Check::RemoveCheckForm do
  # NOTE: not using the shared examples for 'a yes-no question form' because
  # we are performing a custom override of the `#persist!` method.

  let(:question_attribute) { :remove_check }
  let(:answer_value) { 'yes' }

  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      question_attribute => answer_value
    }
  end

  let(:disclosure_check) { instance_double(DisclosureCheck) }

  subject { described_class.new(arguments) }

  describe 'validations on field presence' do
    it { should validate_presence_of(question_attribute, :inclusion) }
  end

  describe '#save' do
    context 'when no disclosure_check is associated with the form' do
      let(:disclosure_check) { nil }

      it 'raises an error' do
        expect { described_class.new(arguments).save }.to raise_error(BaseForm::DisclosureCheckNotFound)
      end
    end

    context 'when answer is `yes`' do
      let(:answer_value) { 'yes' }

      it 'deletes the record' do
        expect(disclosure_check).to receive(:destroy)
        expect(disclosure_check).to receive(:destroyed?).and_return(true)

        expect(described_class.new(arguments).save).to be(true)
      end
    end

    context 'when answer is `no`' do
      let(:answer_value) { 'no' }

      it 'saves the record' do
        expect(disclosure_check).not_to receive(:update)
        expect(disclosure_check).not_to receive(:destroy)
        expect(disclosure_check).not_to receive(:destroyed?)

        expect(described_class.new(arguments).save).to be(true)
      end
    end
  end
end
