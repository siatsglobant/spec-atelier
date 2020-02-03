class CreateLookupTables < ActiveRecord::Migration[6.0]
  def change
    create_table :lookup_tables do |t|
      t.string :category
      t.integer :code
      t.string :value
      t.string :translation_spa
      t.timestamps
    end
    add_index(:lookup_tables, :category)
  end
end
