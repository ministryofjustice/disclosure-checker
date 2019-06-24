require 'rails_helper'

RSpec.describe GovukElementsErrorsHelper do
  def strip_text(text)
    text = text.strip.split("\n").map(&:strip)
    text.delete_if { |line| line == '' }
    text.join
  end

  # Note: This is just a very broad and `happy path` test.
  # It is also coupled to current i18n so, if the strings change,
  # then the HTML fixture will need to also be updated.
  #
  describe '.error_summary' do
    let(:disclosure_check) { DisclosureCheck.new }

    context 'yes_no question' do
      let(:html_output) { GovukElementsErrorsHelper.error_summary(disclosure_check, 'There is an error') }
      let(:html_fixture) { file_fixture('error_summary.html').read }


      it 'outputs the expected markup' do
        disclosure_check.errors.add(:kind, :inclusion)

        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end

    context 'choice question' do
      let(:html_output) { GovukElementsErrorsHelper.error_summary(kind_form, 'Select caution or conviction') }
      let(:html_fixture) { file_fixture('error_summary_choice.html').read }
      let(:kind_form) { Steps::Check::KindForm.build(disclosure_check) }


      it 'choice outputs the expected markup' do
        kind_form.errors.add(:kind, :inclusion)

        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end


    context 'text box' do
      let(:html_output) { GovukElementsErrorsHelper.error_summary(conviction_length_form, 'The length of conviction must be a number, like 3') }
      let(:html_fixture) { file_fixture('error_summary_text_box.html').read }
      let(:conviction_length_form) { Steps::Conviction::ConvictionLengthForm.build(disclosure_check) }


      it 'choice outputs the expected markup' do
        conviction_length_form.errors.add(:conviction_length, :not_a_number)
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end
  end
end
