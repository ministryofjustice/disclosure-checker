module Steps
  module Conviction
    class MotoringDisqualificationEndDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :motoring_disqualification_end_date, Date

      acts_as_gov_uk_date :motoring_disqualification_end_date

      validates_presence_of :motoring_disqualification_end_date
      validates :motoring_disqualification_end_date, sensible_date: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          motoring_disqualification_end_date: motoring_disqualification_end_date
        )
      end
    end
  end
end
