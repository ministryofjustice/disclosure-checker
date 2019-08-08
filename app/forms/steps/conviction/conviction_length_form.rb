module Steps
  module Conviction
    class ConvictionLengthForm < BaseForm
      attribute :conviction_length, String
      delegate :conviction_length_type, to: :disclosure_check

      validates_numericality_of :conviction_length, greater_than: 0, only_integer: true

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
