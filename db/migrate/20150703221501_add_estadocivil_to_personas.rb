class AddEstadocivilToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :estadocivil, :string, limit: 2
  end
end
