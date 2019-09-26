class AddMotoringEndorsementToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :motoring_endorsement, :string
  end
end
