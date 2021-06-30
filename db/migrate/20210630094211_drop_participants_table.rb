class DropParticipantsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :participants
  end
end
