module Backoffice
  class ParticipantsController < ApplicationController
    def index
      @opted_in_participants  = Participant.opted_in
      @opted_out_participants = Participant.opted_out
    end
  end
end
