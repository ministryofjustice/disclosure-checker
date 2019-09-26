class AddMotoringDisqualificationEndDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :motoring_disqualification_end_date, :date
  end
end
