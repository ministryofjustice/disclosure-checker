module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Form < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :<%= step_name.underscore %>, :date

      acts_as_gov_uk_date :<%= step_name.underscore %>

      validates_presence_of :<%= step_name.underscore %>

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          <%= step_name.underscore %>: <%= step_name.underscore %>
        )
      end
    end
  end
end
