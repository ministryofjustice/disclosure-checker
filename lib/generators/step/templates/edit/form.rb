module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Form < BaseForm
      # TODO: Add more attributes or change type if necessary
      attribute :<%= step_name.underscore %>, :string

      # TODO: Delete this method and add different validation if you don't have a value object
      def self.choices
        <%= step_name.camelize %>.string_values
      end
      validates_inclusion_of :<%= step_name.underscore %>, in: choices

      private

      # TODO: Delete this method if you don't have a value object
      def <%= step_name.underscore %>_value
        <%= step_name.camelize %>.new(<%= step_name.underscore %>)
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        # TODO: Update this to persist your form object if you don't have a single value object
        disclosure_check.update(
          <%= step_name.underscore %>: <%= step_name.underscore %>_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
