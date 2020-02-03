class CreateSpecs < ActiveRecord::Migration[6.0]
  def change
    create_table :specs do |t|
      t.string :name
      t.references :item, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
