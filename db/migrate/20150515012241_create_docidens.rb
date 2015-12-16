class CreateDocidens < ActiveRecord::Migration
  def change
    create_table :docidens do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.string :formato
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
