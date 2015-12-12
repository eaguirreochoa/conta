class CreateCargos < ActiveRecord::Migration
  def change
    create_table :cargos do |t|
      t.string :Codigo
      t.string :Nombre
      t.boolean :Activo

      t.timestamps null: false
    end
  end
end
