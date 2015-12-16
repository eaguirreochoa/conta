class CreateMayorHists < ActiveRecord::Migration
  def change
    create_table :mayor_hists do |t|

      t.integer :tlaux1
      t.integer :codtlaux1
      t.integer :tlaux2
      t.integer :codtlaux2
      t.string :tipo, :limit => 3
      t.boolean :esdebito
      t.decimal :debe, :precision => 20, :scale => 8
      t.decimal :haber, :precision => 20, :scale => 8
      t.decimal :debesec, :precision => 20, :scale => 8
      t.decimal :habersec, :precision => 20, :scale => 8
      t.references :empresa, index: true
      t.references :oficina, index: true
      t.references :catalogo, index: true
      t.references :ciclo, index: true
      t.references :periodo, index: true

      t.timestamps null: false
    end
    add_foreign_key :mayor_hists, :empresas
    add_foreign_key :mayor_hists, :oficinas
    add_foreign_key :mayor_hists, :catalogos
    add_foreign_key :mayor_hists, :ciclos
    add_foreign_key :mayor_hists, :periodos
  end
end