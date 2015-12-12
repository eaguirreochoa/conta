class Oficina < ActiveRecord::Base
	def self.id_oficina_nacional
		find_by(id: 1).id
	end
end
