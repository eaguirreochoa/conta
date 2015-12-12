class Cuentabanco < ActiveRecord::Base
  belongs_to :moneda
  belongs_to :entidad
  belongs_to :catalogo
  has_one :libauxdet, as: :libauxdetable
end
