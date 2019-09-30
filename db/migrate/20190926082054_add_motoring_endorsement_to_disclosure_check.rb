class AddMotoringEndorsementToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :motoring_lifetime_ban_to_disclosure_check, :string
  end
end
