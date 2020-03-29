class AddCompensationPaymentOver100ToDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :compensation_payment_over_100, :string
  end
end
