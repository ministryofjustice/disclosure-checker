class AddConvictionMultipleSentencesToDisclosureChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_checks, :conviction_multiple_sentences, :string
  end
end
