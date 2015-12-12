class AddCicloactivoToPeriodo < ActiveRecord::Migration
  def change
    add_column :periodos, :cicloactivo, :boolean
  end
end
