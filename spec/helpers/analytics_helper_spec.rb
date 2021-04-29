require 'rails_helper'

RSpec.describe AnalyticsHelper, type: :helper do
  let(:record) { DisclosureCheck.new(kind: kind, under_age: under_age) }
  let(:kind) { CheckKind::CAUTION }
  let(:under_age) { nil }

  before do
    allow(helper).to receive(:current_disclosure_check).and_return(record)
  end

  describe '#analytics_tracking_id' do
    it 'retrieves the environment variable' do
      expect(ENV).to receive(:[]).with('GA_TRACKING_ID')
      helper.analytics_tracking_id
    end
  end

  describe '#track_transaction' do
    before do
      allow(record).to receive(:id).and_return('12345')
      allow(record).to receive(:kind).and_return('caution')
    end

    it 'sets the transaction attributes to track' do
      helper.track_transaction(name: 'whatever')

      expect(
        helper.content_for(:transaction_data)
      ).to eq("{\"id\":\"12345\",\"name\":\"whatever\",\"sku\":\"caution\",\"quantity\":1}")
    end

    it 'defaults transaction attributes if not present' do
      helper.track_transaction({})

      expect(
        helper.content_for(:transaction_data)
      ).to eq("{\"id\":\"12345\",\"name\":\"caution\",\"sku\":\"caution\",\"quantity\":1}")
    end

    context 'custom dimensions' do
      context 'spent' do
        it 'sets the transaction attributes to track' do
          helper.track_transaction(name: 'whatever', dimensions: { spent: 'yes' })

          expect(
            helper.content_for(:transaction_data)
          ).to match(/"dimension1":"yes"/)
        end
      end

      context 'proceedings' do
        it 'sets the transaction attributes to track' do
          helper.track_transaction(name: 'whatever', dimensions: { proceedings: 3 })

          expect(
            helper.content_for(:transaction_data)
          ).to match(/"dimension2":3/)
        end
      end

      context 'orders' do
        it 'sets the transaction attributes to track' do
          helper.track_transaction(name: 'whatever', dimensions: { orders: 5 })

          expect(
              helper.content_for(:transaction_data)
          ).to match(/"dimension3":5/)
        end
      end
    end
  end

  describe '#transaction_sku' do
    before do
      allow(record).to receive(attr_name).and_return(attr_name)
    end

    context 'conviction_subtype is present' do
      let(:attr_name) { 'conviction_subtype' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'conviction_type is present' do
      let(:attr_name) { 'conviction_type' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'caution_type is present' do
      let(:attr_name) { 'caution_type' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'kind is present' do
      let(:attr_name) { 'kind' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end
  end

  describe '#transaction_sku when not enough steps have been completed' do
    context '`current_disclosure_check` is not present' do
      let(:record) { nil }
      it { expect(helper.transaction_sku).to eq('unknown') }
    end

    context '`current_disclosure_check` is present, but `kind` is not present' do
      let(:kind) { nil }
      it { expect(helper.transaction_sku).to eq('unknown') }
    end
  end

  describe '#youth_check' do
    context '`current_disclosure_check` is not present' do
      let(:record) { nil }
      it { expect(helper.youth_check).to eq('unknown') }
    end

    context '`current_disclosure_check` is present, but `under_age` is not present' do
      let(:under_age) { nil }
      it { expect(helper.youth_check).to eq('unknown') }
    end

    context '`under_age` is present' do
      let(:under_age) { 'yes' }
      it { expect(helper.youth_check).to eq('yes') }
    end
  end
end
