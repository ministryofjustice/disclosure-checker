require 'rails_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end
end

RSpec.describe ApplicationHelper, type: :helper do
  let(:record) { DisclosureCheck.new }

  describe '#step_form' do
    let(:expected_defaults) { {
      url: {
        controller: "application",
        action: :update
      },
      html: {
        class: 'edit_disclosure_check'
      },
      method: :put
    } }
    let(:form_block) { Proc.new {} }

    it 'acts like FormHelper#form_for with additional defaults' do
      expect(helper).to receive(:form_for).with(record, expected_defaults) do |*_args, &block|
        expect(block).to eq(form_block)
      end
      helper.step_form(record, &form_block)
    end

    it 'accepts additional options like FormHelper#form_for would' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(foo: 'bar'))
      helper.step_form(record, { foo: 'bar' })
    end

    it 'appends optional css classes if provided' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(html: {class: %w(test edit_disclosure_check)}))
      helper.step_form(record, html: {class: 'test'})
    end
  end

  describe '#step_header' do
    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'step_header', locals: {path: '/foo/bar'}).and_return('foobar')
      expect(helper.step_header).to eq('foobar')
    end
  end

  describe '#step_subsection' do
    let(:form_object) { double('form object', conviction_subtype: 'conviction_subtype') }

    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'step_subsection', locals: {subsection: 'conviction_subtype'}).and_return('foobar')
      expect(helper.step_subsection(form_object)).to eq('foobar')
    end
  end

  describe '#error_summary' do
    context 'when no form object is given' do
      let(:form_object) { nil }

      it 'returns nil' do
        expect(helper.error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object without errors is given' do
      let(:form_object) { double('form object', errors: []) }

      it 'returns nil' do
        expect(helper.error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object with errors is given' do
      let(:form_object) { double('form object', errors: [:blank]) }
      let(:summary) { double('error summary') }

      let(:title) { helper.content_for(:page_title) }

      before do
        helper.title('A page')
      end

      it 'delegates to GovukElementsErrorsHelper' do
        expect(GovukElementsErrorsHelper).to receive(:error_summary).with(form_object, anything).and_return(summary)

        expect(helper.error_summary(form_object)).to eq(summary)
      end

      it 'prepends the page title with an error hint' do
        expect(GovukElementsErrorsHelper).to receive(:error_summary)
        helper.error_summary(form_object)
        expect(title).to start_with('Error: A page')
      end
    end
  end

  describe '#analytics_tracking_id' do
    it 'retrieves the environment variable' do
      expect(ENV).to receive(:[]).with('GA_TRACKING_ID')
      helper.analytics_tracking_id
    end
  end

  describe 'capture missing translations' do
    before do
      ActionView::Base.raise_on_missing_translations = false
    end

    it 'should not raise an exception, and capture in Sentry the missing translation' do
      expect(Raven).to receive(:capture_exception).with(an_instance_of(I18n::MissingTranslationData))
      expect(Raven).to receive(:extra_context).with(
        {
          locale: :en,
          scope: nil,
          key: 'a_missing_key_here'
        }
      )
      helper.translate('a_missing_key_here')
    end
  end

  describe '#title' do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context 'for a blank value' do
      let(:value) { '' }
      it { expect(title).to eq('Check when a caution or conviction is spent - GOV.UK') }
    end

    context 'for a provided value' do
      let(:value) { 'Test page' }
      it { expect(title).to eq('Test page - Check when a caution or conviction is spent - GOV.UK') }
    end
  end

  describe '#fallback_title' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
      allow(helper).to receive(:controller_name).and_return('my_controller')
      allow(helper).to receive(:action_name).and_return('an_action')
    end

    it 'should notify in Sentry about the missing translation' do
      expect(Raven).to receive(:capture_exception).with(
        StandardError.new('page title missing: my_controller#an_action')
      )
      helper.fallback_title
    end

    it 'should call #title with a blank value' do
      expect(helper).to receive(:title).with('')
      helper.fallback_title
    end
  end

  describe '#display_result' do
    let(:display_result) { helper.display_result(value) }

    context 'is a date' do
      let(:value) { Date.new(2019, 1, 1) }
      it 'returns a formatted date' do
        expect(display_result).to eq(I18n.l(value))
      end
    end

    context 'is not a date' do
      let(:value) { Faker::TvShows::SiliconValley.quote }
      it 'returns a string' do
        expect(display_result).to eq(value)
      end
    end
  end
end
