class CreateCierres < ActiveRecord::Migration
  def change
    create_table :cierres do |t|
      t.datetime :fechaproceso
      t.integer :tipo
      t.string :desc
      t.boolean :activo
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :cierres, :users
  end
end
