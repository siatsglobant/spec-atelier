class CreateSpecTexts < ActiveRecord::Migration[6.0]
  def change
    create_table :spec_texts do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
