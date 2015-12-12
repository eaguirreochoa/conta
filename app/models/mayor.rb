class Mayor < ActiveRecord::Base
	belongs_to :catalogo
	belongs_to :libauxdet, foreign_key: "codtlaux1" 
	belongs_to :oficina,  foreign_key: "oficina_id" 
end
