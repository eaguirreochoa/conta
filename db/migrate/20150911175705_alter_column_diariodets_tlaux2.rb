class AlterColumnDiariodetsTlaux2 < ActiveRecord::Migration
   def self.up
    change_table :diariodets do |t|
      t.change :tlaux2, :integer
    end
  end
  def self.down
    change_table :diariodets do |t|
      t.change :tlaux2, :datetime
    end
  end
end
