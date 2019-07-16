module Steps
  module Conviction
    class ConvictionLengthTypeForm < BaseForm
      attribute :conviction_length_type, String

      validates_inclusion_of :conviction_length_type, in: :choices, if: :disclosure_check

      def choices
        if all_length_options?
          ConvictionLengthType.values
        else
          ConvictionLengthType.values - [ConvictionLengthType::NO_LENGTH]
        end.map(&:to_s)
      end

      private

      def changed?
        disclosure_check.conviction_length_type != conviction_length_type
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update(
          conviction_length_type: conviction_length_type,
          # The following are dependent attributes that need to be reset if form changes
          conviction_length: nil
        )
      end

      def all_length_options?
        conviction_type.eql?(ConvictionType::COMMUNITY_ORDER) ||
          conviction_subtype.eql?(ConvictionType::HOSPITAL_ORDER)
      end
    end
  end
end
