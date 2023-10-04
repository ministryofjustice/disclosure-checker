class AddSingleSentenceOver4ToDisclosureChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_checks, :single_sentence_over4, :string
  end
end
