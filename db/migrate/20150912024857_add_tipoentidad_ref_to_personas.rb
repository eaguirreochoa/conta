class AddTipoentidadRefToPersonas < ActiveRecord::Migration
  def change
    add_reference :personas, :tipoentidad, index: true
    add_foreign_key :personas, :tipoentidads
  end
end
