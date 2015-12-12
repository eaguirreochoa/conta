class AddEmpresaRefToCierres < ActiveRecord::Migration
  def change
    add_reference :cierres, :empresa, index: true
    add_foreign_key :cierres, :empresas
  end
end
