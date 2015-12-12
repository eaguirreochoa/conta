class CreateDocidenexts < ActiveRecord::Migration
  def change
    create_table :docidenexts do |t|
      t.string :Codigo
      t.string :Nombre
      t.string :Sigla
      t.boolean :Activo
      t.references :Dociden, index: true

      t.timestamps null: false
    end
    add_foreign_key :docidenexts, :Docidens
  end
end
