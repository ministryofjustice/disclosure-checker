module Calculators
  module Multiples
    class Proceedings
      attr_reader :check_group

      delegate :size, to: :disclosure_checks

      def initialize(check_group)
        @check_group = check_group
      end

      def spent_date
        max_expiry(expiry_dates)
      end

      def spent_date_without_relevant_orders
        max_expiry(non_relevant_expiry_dates)
      end

      def spent?
        return true  if spent_date == ResultsVariant::SPENT_SIMPLE
        return false if spent_date == ResultsVariant::NEVER_SPENT
        return false if spent_date == ResultsVariant::INDEFINITE

        spent_date.past?
      end

      def kind
        CheckKind.find_constant(first_disclosure_check.kind)
      end

      def conviction?
        kind.inquiry.conviction?
      end

      # When there are more than one sentence (checks),
      # all will share the same conviction date.
      delegate :conviction_date, to: :first_disclosure_check

    private

      def max_expiry(expiry_dates)
        return ResultsVariant::NEVER_SPENT if expiry_dates.include?(ResultsVariant::NEVER_SPENT)
        return ResultsVariant::INDEFINITE  if expiry_dates.include?(ResultsVariant::INDEFINITE)

        # Pick the latest date in the collection
        # If there is only one sentence then it returns that date
        expiry_dates.max
      end

      def disclosure_checks
        @disclosure_checks ||= check_group.disclosure_checks.completed
      end

      def first_disclosure_check
        @first_disclosure_check ||= disclosure_checks.first
      end

      def expiry_dates
        @expiry_dates ||= disclosure_checks.map(
          &method(:expiry_date_for)
        )
      end

      def non_relevant_expiry_dates
        @non_relevant_expiry_dates ||= disclosure_checks.reject(&:no_drag_through?).map(
          &method(:expiry_date_for)
        )
      end

      def expiry_date_for(check)
        CheckResult.new(disclosure_check: check).expiry_date
      end
    end
  end
end
