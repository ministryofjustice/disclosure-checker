class AddCompensationPaidToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :compensation_paid, :string
  end
end
