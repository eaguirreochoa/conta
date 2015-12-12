class Cliente < Persona
	# has_one :libauxdet, as: :libauxdetable
	# before_create :crea_lib_aux_cliente
	# before_update :actualiza_name_lib_aux

	# accepts_nested_attributes_for :libauxdet, allow_destroy: true

 #    def fullname
 #        [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
 #    end
    
	# def crea_lib_aux_cliente
	#     #@diario.build_correlcbte(nro: @nro_comprobante)
	#  	build_libauxdet(:name => [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip)
	# end

	# def actualiza_name_lib_aux
	# 	if self.esjuridica
	# 		libauxdet.name = self.Nombres.strip
	# 	else
	# 		libauxdet.name = [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
	# 	end
	# end	
end
