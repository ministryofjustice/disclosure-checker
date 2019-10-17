require 'rails_helper'

RSpec.describe Steps::Check::CheckYourAnswersController, type: :controller do
    describe '#show' do
      let(:disclosure_check) { build(:disclosure_check, kind: kind) }

      before do
        allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
      end

      context 'for a caution' do
        let(:kind) { 'caution' }

        it 'render template' do
          get :show

          expect(response).to render_template(:show)
        end
      end

      context 'for a conviction' do
        let(:kind) { 'conviction' }

        before do
          allow_any_instance_of(
            ConvictionResultPresenter
          ).to receive(:expiry_date).and_return(Date.yesterday)
        end

        it 'render template' do
          get :show

          expect(response).to render_template(:show)
        end
      end

    end
end
