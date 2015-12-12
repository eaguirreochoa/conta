class AddPersonaIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :persona_id, :integer
  end
end
