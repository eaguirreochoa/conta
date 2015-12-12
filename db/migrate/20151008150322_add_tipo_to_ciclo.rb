class AddTipoToCiclo < ActiveRecord::Migration
  def change
    add_column :ciclos, :tipo, :string, limit: 3
  end
end
