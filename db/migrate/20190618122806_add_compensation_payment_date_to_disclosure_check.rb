class AddCompensationPaymentDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :compensation_payment_date, :date
  end
end
