module Steps
  module Conviction
    class ConvictionSubtypeForm < BaseForm
      attribute :conviction_subtype, String

      validates_inclusion_of :conviction_subtype, in: :choices, if: :disclosure_check

      def values
        conviction_type.children
      end

      def i18n_attribute
        conviction_type
      end

      private

      def choices
        values.map(&:to_s)
      end

      def conviction_type
        ConvictionType.new(disclosure_check.conviction_type)
      end

      def changed?
        disclosure_check.conviction_subtype != conviction_subtype
      end

      def motoring_endorsement
        return GenericYesNo::YES if motoring_penalty_notice?

        nil
      end

      def motoring_penalty_notice?
        [
          ConvictionType::ADULT_PENALTY_NOTICE,
          ConvictionType::YOUTH_PENALTY_NOTICE,
        ].map(&:to_s).include?(conviction_subtype)
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update(
          conviction_subtype: conviction_subtype,
          # The following are dependent attributes that need to be reset if form changes
          known_date: nil,
          conviction_bail: nil,
          conviction_bail_days: nil,
          conviction_length: nil,
          conviction_length_type: nil,
          compensation_paid: nil,
          compensation_payment_date: nil,
          motoring_endorsement: motoring_endorsement
        )
      end
    end
  end
end
