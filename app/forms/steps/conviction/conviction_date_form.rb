module Steps
  module Conviction
    class ConvictionDateForm < BaseForm
      attribute :conviction_date, MultiParamDate
      attribute :approximate_conviction_date, Boolean

      validates_presence_of :conviction_date
      validates :conviction_date, sensible_date: true

    private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_date: conviction_date,
          approximate_conviction_date: approximate_conviction_date
        )
      end
    end
  end
end
