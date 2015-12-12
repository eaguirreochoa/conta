class AddFechanacimientoToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :fechanacimiento, :datetime
  end
end
