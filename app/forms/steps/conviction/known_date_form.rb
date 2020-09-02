module Steps
  module Conviction
    class KnownDateForm < BaseForm
      attribute :known_date, MultiParamDate
      attribute :approximate_known_date, Boolean

      validates_presence_of :known_date
      validates :known_date, sensible_date: true

      # As we reuse this form object in multiple views, this is the attribute
      # that will be used to choose the locales for legends and hints.
      def i18n_attribute
        conviction_subtype
      end

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          known_date: known_date,
          approximate_known_date: approximate_known_date
        )
      end
    end
  end
end
