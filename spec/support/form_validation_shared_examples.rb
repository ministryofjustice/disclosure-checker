RSpec.shared_examples 'a value object form' do |options|
  context 'when no disclosure_check is associated with the form' do
    let(:disclosure_check) { nil }
    let(options[:attribute_name]) { options[:example_value] }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::DisclosureCheckNotFound)
    end
  end

  context 'when attribute is not given' do
    let(options[:attribute_name]) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(options[:attribute_name]) { 'INVALID VALUE' }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end
end

RSpec.shared_examples 'a yes-no question form' do |options|
  let(:question_attribute) { options[:attribute_name] }
  let(:answer_value) { 'yes' }

  let(:reset_when_yes) { options.fetch(:reset_when_yes, []) }
  let(:reset_when_no)  { options.fetch(:reset_when_no,  []) }

  let(:linked_attribute)  { options[:linked_attribute] }
  let(:linked_attribute_value) { 'details' }
  let(:linked_attributes) { linked_attribute ? { linked_attribute => linked_attribute_value } : {} }

  let(:arguments) {
    {
      disclosure_check: disclosure_check,
      question_attribute => answer_value
    }.merge(linked_attributes)
  }

  let(:disclosure_check) { instance_double(DisclosureCheck) }

  subject { described_class.new(arguments) }

  def attributes_to_reset(attrs)
    Hash[attrs.collect {|att| [att, nil]}]
  end

  describe 'validations on field presence' do
    it { should validate_presence_of(question_attribute, :inclusion) }

    if options[:linked_attribute]
      context 'when answer is yes, validates presence of linked attribute' do
        let(:answer_value) { 'yes' }
        it { should validate_presence_of(linked_attribute) }
      end

      context 'when answer is no, does not validate presence of linked attribute' do
        let(:answer_value) { 'no' }
        it { should_not validate_presence_of(linked_attribute) }
      end
    end
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
      let(:additional_attributes) { attributes_to_reset(reset_when_yes).merge(linked_attributes) }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          { options[:attribute_name] => GenericYesNo::YES }.merge(additional_attributes)
        ).and_return(true)
        expect(described_class.new(arguments).save).to be(true)
      end
    end

    context 'when answer is `no`' do
      let(:answer_value) { 'no' }
      let(:additional_attributes) { attributes_to_reset(reset_when_no) }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with( hash_including(
            { options[:attribute_name] => GenericYesNo::NO }.merge(additional_attributes)
          )
        ).and_return(true)
        expect(described_class.new(arguments).save).to be(true)
      end
    end
  end
end

RSpec.shared_examples 'a date question form' do |options|
  let(:question_attribute) { options[:attribute_name] }

  let(:arguments) { {
    disclosure_check: disclosure_check,
    question_attribute => date_value
  } }

  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:date_value) { 3.months.ago.to_date }

  subject { described_class.new(arguments) }

  describe '#save' do
    if options[:allow_empty_date].nil?
      it { should validate_presence_of(question_attribute) }
    end

    context 'when no disclosure_check is associated with the form' do
      let(:disclosure_check) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::DisclosureCheckNotFound)
      end
    end

    context 'date validation' do
      context 'when date is not given' do
        let(:date_value) { nil }

        if options[:allow_empty_date].nil?
          it 'returns false' do
            expect(subject.save).to be(false)
          end

          it 'has a validation error on the field' do
            expect(subject).to_not be_valid
            expect(subject.errors.added?(question_attribute, :blank)).to eq(true)
          end
        end
      end

      context 'when date is invalid' do
        let(:date_value) { Date.new(18, 10, 31) } # 2-digits year (18)

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(question_attribute, :invalid)).to eq(true)
        end
      end

      if options[:allow_future].nil?
        context 'when date is in the future' do
          let(:date_value) { Date.tomorrow }

          it 'returns false' do
            expect(subject.save).to be(false)
          end

          it 'has a validation error on the field' do
            expect(subject).to_not be_valid
            expect(subject.errors.added?(question_attribute, :future)).to eq(true)
          end
        end
      else
        context 'when date in the future is allowed' do
          let(:date_value) { Date.tomorrow }

          it 'has no validation errors on the field' do
            expect(subject).to be_valid
            expect(subject.errors.added?(question_attribute, :future)).to eq(false)
          end

          it 'returns true' do
              expect(disclosure_check).to receive(:update).with(
                question_attribute => date_value
              ).and_return(true)

              expect(subject.save).to be(true)
            end
        end
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          question_attribute => 3.months.ago.to_date
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
