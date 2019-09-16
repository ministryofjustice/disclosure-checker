module Backoffice
  class ParticipantsController < ApplicationController
    def index
      @opted_in_participants  = Participant.opted_in_participant
      @opted_out_participants = Participant.opted_out_participant
    end
  end
end
