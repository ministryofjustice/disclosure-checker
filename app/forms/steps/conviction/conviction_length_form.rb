module Steps
  module Conviction
    class ConvictionLengthForm < BaseForm
      attribute :conviction_length, String
      delegate :conviction_length_type, to: :disclosure_check

      HUNDRED_YEARS_IN_DAYS = 36_524

      validates_numericality_of :conviction_length, greater_than: 0, less_than: HUNDRED_YEARS_IN_DAYS, only_integer: true
      validates :conviction_length, sentence_length: true, if: :disclosure_check

      def i18n_attribute
        disclosure_check.conviction_length_type
      end

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_length: conviction_length
        )
      end
    end
  end
end
