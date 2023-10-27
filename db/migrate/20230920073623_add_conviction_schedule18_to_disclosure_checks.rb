class AddConvictionSchedule18ToDisclosureChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_checks, :conviction_schedule18, :string
  end
end
