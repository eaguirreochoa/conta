class Fondo < ActiveRecord::Base
  belongs_to :entidad
  belongs_to :empresa
end
