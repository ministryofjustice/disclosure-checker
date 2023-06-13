module Steps
  module Conviction
    class ConvictionLengthTypeForm < BaseForm
      attribute :conviction_length_type, String

      validates_inclusion_of :conviction_length_type, in: :choices, if: :disclosure_check

      def values
        ConvictionLengthChoices.choices(
          conviction_subtype:,
        )
      end

      def i18n_attribute
        conviction_subtype
      end

    private

      def choices
        values.map(&:to_s)
      end

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
    end
  end
end
