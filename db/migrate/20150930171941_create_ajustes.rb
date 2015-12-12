class CreateAjustes < ActiveRecord::Migration
  def change
    create_table :ajustes do |t|
      t.datetime :fechaproceso
      t.integer :tipo
      t.decimal :indiceant, :precision => 20, :scale => 8
      t.decimal :indiceact, :precision => 20, :scale => 8
      t.boolean :activo
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :ajustes, :users
  end
end
