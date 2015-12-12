class CreateNivels < ActiveRecord::Migration
  def change
    create_table :nivels do |t|
      t.integer :numnivel
      t.integer :nrodigitos
      t.integer :nrodigitostotal
      t.boolean :esmoneda
      t.integer :nrodigitosmoneda

      t.timestamps null: false
    end
  end
end
