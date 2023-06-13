module Steps
  module Conviction
    class ConvictionBailDaysForm < BaseForm
      attribute :conviction_bail_days, String

      validates_numericality_of :conviction_bail_days,
                                greater_than: 0, allow_blank: true, only_integer: true

    private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update!(
          conviction_bail_days:,
        )
      end
    end
  end
end
