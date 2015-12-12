class AddGeneroToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :genero, :boolean
  end
end
