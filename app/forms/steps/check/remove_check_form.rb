module Steps
  module Check
    class RemoveCheckForm < BaseForm
      include SingleQuestionForm

      validates_presence_of :remove_check

      yes_no_attribute :remove_check

    private

      # We do not store this in the database, so when user answers "No" we return true
      # Otherwise if the record is successfully destroyed, return true
      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        return true if remove_check.no?

        disclosure_check.destroy!
        disclosure_check.destroyed?
      end
    end
  end
end
