class AddSchedule18OffenceToDisclosureCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_checks, :schedule_18_offence, :boolean, default: false
  end
end
