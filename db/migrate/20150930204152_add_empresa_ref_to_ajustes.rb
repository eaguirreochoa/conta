class AddEmpresaRefToAjustes < ActiveRecord::Migration
  def change
    add_reference :ajustes, :empresa, index: true
    add_foreign_key :ajustes, :empresas
  end
end
