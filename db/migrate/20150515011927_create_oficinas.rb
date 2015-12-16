class CreateOficinas < ActiveRecord::Migration
  def change
    create_table :oficinas do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.string :direccion
      t.string :telefono
      t.string :correo
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
