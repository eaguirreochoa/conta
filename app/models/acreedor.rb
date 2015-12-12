class Acreedor < Persona
	# has_one :libauxdet, as: :libauxdetable #, foreign_key: "libauxdetable_id"
	# #has_one :libauxdet, foreign_key: "libauxdetable_id"
	# before_create :crea_lib_aux_acreedor
	# before_update :actualiza_name_lib_aux
	# accepts_nested_attributes_for :libauxdet, allow_destroy: true

 #    def fullname
 #        [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
 #    end
    
	# def crea_lib_aux_acreedor
	#     #@diario.build_correlcbte(nro: @nro_comprobante)
	#  	build_libauxdet(:name => [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip)
	# end

	# def actualiza_name_lib_aux
	# 	if self.esjuridica
	# 		libauxdet.name = self.Nombres.strip
	# 		#libauxdet.update(name: self.Nombres)
	# 	else
	# 		self.libauxdet.name = [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
	# 		#libauxdet.update(name: [self.Appaterno, self.Apmaterno, self.Nombres].join(" "))
	# 	end
	# end		
end
