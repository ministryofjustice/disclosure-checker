module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report,
                  :proceedings

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @proceedings = []

        process!
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      def spent_date_for(proceeding)
        return unless disclosure_report.completed?

        conviction_date = proceeding.conviction_date
        spent_date = proceeding.spent_date

        # Cautions are always dealt with separately and do not have drag-through
        return spent_date unless proceeding.conviction?

        # Comparison of dates between different convictions
        # should be done without relevant order dates
        spent_date_without_relevant_order = proceeding.spent_date_without_relevant_orders

        # We have to loop through the other convictions and check if the spent date
        # of this conviction overlaps with the rehabilitation of another one and if so,
        # then the spent date of this conviction becomes the spent date of the other.
        #
        # One important rule:
        #
        #   Assuming there are overlaps, everything that has an end date given before a
        #   "never spent" conviction becomes "never spent". Everything afterwards is not
        #   affected by the "never spent". Same for "indefinite".
        #
        convictions_by_date.without(proceeding).each do |conviction|
          other_conviction_date = conviction.conviction_date

          # Pick the spent date from memory if we have it, otherwise get it fresh.
          other_spent_date = dates_memory.fetch(conviction, conviction.spent_date_without_relevant_orders)

          # solo relevant order
          # if there's only one sentence and it is a relevant order
          # then _spent_date_without_relevant_orders_ is nil which means it's not a date
          # and we can't proceed to compare overlapping times (neither should we)
          # because relevant orders do not dictacte the spent_date of another conviction.
          next if other_spent_date.nil?
          next if spent_date_without_relevant_order.nil?

          # The comparison to know if there's an overlap in conviction dates
          # should be done without the relevant order
          # because relevant orders do not dictacte the spent_date of another conviction.
          next unless within_other_conviction_date_and_spent_date?(
            proceeding, spent_date, other_conviction_date, other_spent_date
          )

          next if conviction_date > other_conviction_date

          # This comparison determines wether the relevant order spent date is the longest
          # within the same conviction and also when compared to another conviction spent date.
          # see graph in docs/results/08_relevant_order_3.png
          next if spent_date.to_date >= spent_date_without_relevant_order.to_date &&
                  spent_date.to_date >= other_spent_date.to_date

          # If the spent date falls inside another rehabilitation, we do drag-through,
          # saving this new spent date in the memory for later use.
          # Note: `other_spent_date` could be NEVER_SPENT or INDEFINITE (not real dates).
          spent_date = dates_memory[proceeding] = other_spent_date
        end

        spent_date
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity

      def all_spent?
        proceedings.all?(&:spent?)
      end

      private

      def within_other_conviction_date_and_spent_date?(proceeding, spent_date, other_conviction_date, other_spent_date)
        # We should first check wether the proceeding spent date has been affected
        # by previous comparisons, if so, we should use the value assigned to _spent_date_
        # otherwise we continue to compare spent dates with _spent_date_without_relevant_orders_

        if spent_date == proceeding.spent_date
          proceeding.spent_date_without_relevant_orders.to_date.in?(
            other_conviction_date..other_spent_date.to_date
          )
        else
          spent_date.to_date.in?(
            other_conviction_date..other_spent_date.to_date
          )
        end
      end

      def dates_memory
        @_dates_memory ||= {}
      end

      def convictions_by_date
        @_convictions ||= proceedings.select(&:conviction?).sort_by(&:conviction_date)
      end

      # The order of the `proceedings` collection is the order in which
      # the user entered their cautions and/or convictions.
      def process!
        disclosure_report.check_groups.with_completed_checks.each do |check_group|
          @proceedings.append(Proceedings.new(check_group))
        end

        self
      end
    end
  end
end
