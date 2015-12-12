class CreateCorrelcbtes < ActiveRecord::Migration
  def change
    create_table :correlcbtes do |t|
      t.integer :nro
      t.boolean :activo
      t.references :tipocomprobante, index: true
      t.references :empresa, index: true
      t.references :periodo, index: true

      t.timestamps null: false
    end
    add_foreign_key :correlcbtes, :tipocomprobantes
    add_foreign_key :correlcbtes, :empresas
    add_foreign_key :correlcbtes, :periodos
  end
end
