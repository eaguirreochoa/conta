class CreateCargos < ActiveRecord::Migration
  def change
    create_table :cargos do |t|
      t.string :codigo
      t.string :nombre
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
