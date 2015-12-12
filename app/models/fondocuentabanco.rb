class Fondocuentabanco < ActiveRecord::Base
  belongs_to :cuentabanco
  belongs_to :fondo
end
