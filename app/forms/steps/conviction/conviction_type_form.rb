module Steps
  module Conviction
    class ConvictionTypeForm < BaseForm
      attribute :conviction_type, String

      def self.choices
        ConvictionType::PARENT_TYPES.map(&:to_s)
      end
      validates_inclusion_of :conviction_type, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_type: conviction_type
        )
      end
    end
  end
end
