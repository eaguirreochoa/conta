class CreateDiariodets < ActiveRecord::Migration
  def change
    create_table :diariodets do |t|
      t.integer :tlaux1
      t.string :codtlaux2
      t.datetime :tlaux2
      t.string :codtlaux2
      t.string :glosa
      t.decimal :debe, :precision => 20, :scale => 8
      t.decimal :haber, :precision => 20, :scale => 8
      t.decimal :debesec, :precision => 20, :scale => 8
      t.decimal :habersec, :precision => 20, :scale => 8
      t.decimal :tcsec, :precision => 20, :scale => 8
      t.decimal :debeori, :precision => 20, :scale => 8
      t.decimal :haberori, :precision => 20, :scale => 8
      t.decimal :tcori, :precision => 20, :scale => 8
      t.references :catalogo, index: true
      t.references :oficina, index: true
      t.references :fondo, index: true
      t.references :moneda, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :diariodets, :catalogos
    add_foreign_key :diariodets, :oficinas
    add_foreign_key :diariodets, :fondos
    add_foreign_key :diariodets, :monedas
    add_foreign_key :diariodets, :users
  end
end
