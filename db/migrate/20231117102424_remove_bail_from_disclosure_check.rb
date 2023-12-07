class RemoveBailFromDisclosureCheck < ActiveRecord::Migration[6.1]
  def up
    change_table :disclosure_checks, bulk: true do |t|
      t.remove :conviction_bail_days
      t.remove :conviction_bail
    end
  end

  def down
    change_table :disclosure_checks, bulk: true do |t|
      t.add :conviction_bail_days, :integer
      t.add :conviction_bail, :string
    end
  end
end
