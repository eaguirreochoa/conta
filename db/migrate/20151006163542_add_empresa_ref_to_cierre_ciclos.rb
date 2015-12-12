class AddEmpresaRefToCierreCiclos < ActiveRecord::Migration
  def change
    add_reference :cierre_ciclos, :empresa, index: true
    add_foreign_key :cierre_ciclos, :empresas
  end
end
