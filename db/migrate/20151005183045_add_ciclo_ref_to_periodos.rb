class AddCicloRefToPeriodos < ActiveRecord::Migration
  def change
    add_reference :periodos, :ciclo, index: true
    add_foreign_key :periodos, :ciclos
  end
end
