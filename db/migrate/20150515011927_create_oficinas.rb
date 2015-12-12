class CreateOficinas < ActiveRecord::Migration
  def change
    create_table :oficinas do |t|
      t.string :Codigo
      t.string :Nombre
      t.string :Sigla
      t.string :Direccion
      t.string :Telefono
      t.string :Correo
      t.boolean :Activo

      t.timestamps null: false
    end
  end
end
