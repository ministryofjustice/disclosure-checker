module Steps
  module Mvp
    class InfoController < Steps::MvpStepController
      before_action :validate_reference

      def show
        # @form_object = InfoForm.build(participant_record)
      end

      private

      def reference
        params[:id].to_s
      end

      def validate_reference
        Participant.valid_reference?(reference) ||
          (raise "Participant reference not found: '#{reference}'")
      end

      def participant_record
        @_participant_record ||= Participant.touch_or_create_by(
          reference: reference
        )
      end
    end
  end
end
