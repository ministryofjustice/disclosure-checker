module Steps
  module Conviction
    class ConvictionTypeForm < BaseForm
      attribute :conviction_type, String

      validates_inclusion_of :conviction_type, in: :choices, if: :disclosure_check

      def choices
        list_conviction_types.map(&:to_s)
      end

      def under_age
        disclosure_check.under_age
      end

      private

      def list_conviction_types
        return under_eighteen if under_age

        ConvictionType::PARENT_TYPES
      end

      def under_eighteen
        ConvictionType::PARENT_TYPES.select { |value| value.under_eighteen.eql?(true) }
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_type: conviction_type
        )
      end
    end
  end
end
