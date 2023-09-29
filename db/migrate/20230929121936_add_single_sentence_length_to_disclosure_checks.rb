class AddSingleSentenceLengthToDisclosureChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_checks, :single_sentence_length, :string
  end
end
