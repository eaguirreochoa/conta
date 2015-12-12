class RemovecicloactivoFromPeriodos < ActiveRecord::Migration
 	def change
        remove_column :periodos, :cicloactivo, :boolean
    end
end
