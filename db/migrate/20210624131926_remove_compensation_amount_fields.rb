class RemoveCompensationAmountFields < ActiveRecord::Migration[6.1]
  def change
    # rubocop:disable Rails/BulkChangeTable
    remove_column :disclosure_checks, :compensation_payment_over_100, :string
    remove_column :disclosure_checks, :compensation_receipt_sent, :string
    # rubocop:enable Rails/BulkChangeTable
  end
end
