class CreateLibroauxiliars < ActiveRecord::Migration
  def change
    create_table :libroauxiliars do |t|
      t.string :categoria
      t.string :descripcion
      t.boolean :selista
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
