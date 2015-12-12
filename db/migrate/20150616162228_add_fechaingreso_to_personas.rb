class AddFechaingresoToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :fechaingreso, :datetime
  end
end
