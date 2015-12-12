class CreateDiarios < ActiveRecord::Migration
  def change
    create_table :diarios do |t|
      t.integer :nrocbte
      t.datetime :fechacbte
      t.string :glosagral
      t.boolean :esanulado
      t.string :estado, limit: 2
      t.references :origenasiento, index: true
      t.references :tipocomprobante, index: true
      t.references :empresa, index: true

      t.timestamps null: false
    end
    add_foreign_key :diarios, :origenasientos
    add_foreign_key :diarios, :tipocomprobantes
    add_foreign_key :diarios, :empresas
  end
end
