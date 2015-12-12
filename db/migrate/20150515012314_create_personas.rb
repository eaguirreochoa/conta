class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :Codigo
      t.string :Nombres
      t.string :Appaterno
      t.string :Apmaterno
      t.string :Apcasada
      t.string :Di
      t.string :Telefono
      t.string :Correo
      t.string :type
      t.references :Oficina, index: true
      t.references :Cargo, index: true
      t.references :Dociden, index: true

      t.timestamps null: false
    end
    add_foreign_key :personas, :Oficinas
    add_foreign_key :personas, :Cargos
    add_foreign_key :personas, :Docidens
  end
end
