class ChangeOptedInToOptedOutInParticipants < ActiveRecord::Migration[5.2]
  def change
    rename_column :participants, :opted_in, :opted_out
  end
end
