class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }
end
