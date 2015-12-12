class AddEstransaccionalToNivels < ActiveRecord::Migration
  def change
    add_column :nivels, :estransaccional, :boolean
  end
end
