module Steps
  module Mvp
    class InfoController < Steps::MvpStepController
      before_action :validate_reference

      def edit; end

      private

      def reference
        params[:id].to_s
      end

      def validate_reference
        Participant.valid_reference?(reference) ||
          (raise "Participant reference not found: '#{reference}'")
      end
    end
  end
end
