module Steps
  module Conviction
    class ConvictionSubtypeForm < BaseForm
      attribute :conviction_subtype, String

      validates_inclusion_of :conviction_subtype, in: :choices, if: :disclosure_check

      def choices
        conviction_subtypes.map(&:to_s)
      end

      private

      def conviction_subtypes
        ConvictionType.new(conviction_type).children
      end

      def changed?
        disclosure_check.conviction_subtype != conviction_subtype
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update(
          conviction_subtype: conviction_subtype,
          # The following are dependent attributes that need to be reset if form changes
          known_date: nil,
          conviction_length: nil,
          conviction_length_type: nil,
          compensation_paid: nil,
          compensation_payment_date: nil
        )
      end
    end
  end
end
