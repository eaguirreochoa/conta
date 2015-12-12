class AddCodigoToDiario < ActiveRecord::Migration
  def change
    add_column :diarios, :codigo, :string
  end
end
