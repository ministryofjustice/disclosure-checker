class AddCompensationReceiptSentToDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :compensation_receipt_sent, :string
  end
end
