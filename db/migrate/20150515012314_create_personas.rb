class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :codigo
      t.string :nombres
      t.string :appaterno
      t.string :apmaterno
      t.string :apcasada
      t.string :di
      t.string :telefono
      t.string :correo
      t.string :type
      t.references :oficina, index: true
      t.references :cargo, index: true
      t.references :dociden, index: true

      t.timestamps null: false
    end
    add_foreign_key :personas, :oficinas
    add_foreign_key :personas, :cargos
    add_foreign_key :personas, :docidens
  end
end
