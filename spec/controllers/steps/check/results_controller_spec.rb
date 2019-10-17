require 'rails_helper'

RSpec.describe Steps::Check::ResultsController, type: :controller do
  it_behaves_like 'a completion step controller'

  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check, kind: kind) }
    let(:enable_multiples) { false }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
      allow(controller).to receive(:enable_multiples?).and_return(enable_multiples)
    end


    context 'show check your answers' do
      let(:enable_multiples) { true }
      let(:kind) { 'caution' }

      it 'show result page' do
        get :show, params: { show_results: true }

        expect(response).to render_template(:show)
      end

      it 'redirect to check your answer' do
        get :show

        expect(response).to redirect_to(steps_check_check_your_answers_path)
      end
    end


    context 'for a caution' do
      let(:kind) { 'caution' }

      it 'assigns the correct presenter' do
        get :show

        expect(response).to render_template(:show)
        expect(assigns[:presenter]).to be_a_kind_of(CautionResultPresenter)
      end
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }

      # We are not testing the view variants here, as we've already tested
      # the method `#variant` in the presenters.
      before do
        allow_any_instance_of(
          ConvictionResultPresenter
        ).to receive(:expiry_date).and_return(Date.yesterday)
      end

      it 'assigns the correct presenter' do
        get :show

        expect(response).to render_template(:show)
        expect(assigns[:presenter]).to be_a_kind_of(ConvictionResultPresenter)
      end
    end

    context 'for an unknown kind' do
      let(:kind) { 'foobar' }

      it 'assigns the correct presenter' do
        expect { get :show }.to raise_error(TypeError)
      end
    end
  end
end
