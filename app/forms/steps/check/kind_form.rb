module Steps
  module Check
    class KindForm < BaseForm
      attribute :kind, String

      def self.choices
        CheckKind.string_values
      end

      validates_inclusion_of :kind, in: choices

    private

      def changed?
        disclosure_check.kind != kind
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update!(
          kind:,
          # The following are dependent attributes that need to be reset if form changes
          under_age: nil,
          caution_type: nil,
          conviction_type: nil,
          conviction_subtype: nil,
          conviction_date: nil,
        )
      end
    end
  end
end
