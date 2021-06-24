class RemoveCompensationAmountFields < ActiveRecord::Migration[6.1]
  def change
    remove_column :disclosure_checks, :compensation_payment_over_100, :string
    remove_column :disclosure_checks, :compensation_receipt_sent, :string
  end
end
