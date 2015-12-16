class CreateDocidenexts < ActiveRecord::Migration
  def change
    create_table :docidenexts do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.boolean :activo
      t.references :dociden, index: true

      t.timestamps null: false
    end
    add_foreign_key :docidenexts, :docidens
  end
end
