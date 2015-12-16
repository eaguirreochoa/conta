class CreatePeriodos < ActiveRecord::Migration
  def change
    create_table :periodos do |t|
      t.datetime :fini
      t.datetime :ffin
      t.integer :nro
      t.string :gestion, limit: 5
      t.boolean :activo
      t.references :empresa, index: true

      t.timestamps null: false
    end
    add_foreign_key :periodos, :empresas
  end
end
