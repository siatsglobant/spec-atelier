class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.references :section, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
