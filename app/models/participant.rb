class Participant < ApplicationRecord
  scope :opted_in, -> { where(opted_out: 'no') }
  scope :opted_out, -> { where(opted_out: 'yes') }

  class << self
    def valid_reference?(reference)
      Rails.configuration.participants.include?(
        Digest::SHA256.hexdigest(reference)
      )
    end

    def touch_or_create_by(reference:)
      Participant.find_or_create_by(
        reference: reference
      ).increment_access_count
    end
  end

  # Using `+= 1` instead of `#increment` so the `updated_at` column
  # gets also updated as part of the record save.
  # Returns the instance.
  #
  def increment_access_count
    self.access_count += 1
    save && self
  end
end
