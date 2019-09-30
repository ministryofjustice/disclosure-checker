class AddMotoringLifetimeBanToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :motoring_lifetime_ban, :string
  end
end
