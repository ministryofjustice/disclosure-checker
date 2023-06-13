module Steps
  module Conviction
    class KnownDateForm < BaseForm
      attribute :known_date, MultiParamDate
      attribute :approximate_known_date, Boolean

      validates_presence_of :known_date
      validates :known_date, sensible_date: true
      validate :after_conviction_date?

      # As we reuse this form object in multiple views, this is the attribute
      # that will be used to choose the locales for legends and hints.
      def i18n_attribute
        conviction_subtype
      end

    private

      def after_conviction_date?
        return if known_date.blank? || disclosure_check.conviction_date.blank?

        errors.add(:known_date, :after_conviction_date) if known_date < disclosure_check.conviction_date
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update!(
          known_date:,
          approximate_known_date:,
        )
      end
    end
  end
end
