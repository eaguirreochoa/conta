class AddPeriodoRefToCierres < ActiveRecord::Migration
  def change
    add_reference :cierres, :periodo, index: true
    add_foreign_key :cierres, :periodos
  end
end
