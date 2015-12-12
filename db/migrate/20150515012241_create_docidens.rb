class CreateDocidens < ActiveRecord::Migration
  def change
    create_table :docidens do |t|
      t.string :Codigo
      t.string :Nombre
      t.string :Sigla
      t.string :Formato
      t.boolean :Activo

      t.timestamps null: false
    end
  end
end
