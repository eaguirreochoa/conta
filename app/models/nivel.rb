class Nivel < ActiveRecord::Base

	def self.nivel_transac
		find_by(estransaccional: true, activo: true ).numnivel
	end

	def self.nivel_capitulo
		find_by(nombre: "CLASE" , activo: true ).numnivel
	end
end

 