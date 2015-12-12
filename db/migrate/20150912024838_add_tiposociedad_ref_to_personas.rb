class AddTiposociedadRefToPersonas < ActiveRecord::Migration
  def change
    add_reference :personas, :tiposociedad, index: true
    add_foreign_key :personas, :tiposociedads
  end
end
