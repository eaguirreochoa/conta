class Persona < ActiveRecord::Base  
  #belongs_to :Oficina
  #belongs_to :Cargo
  #belongs_to :Dociden
  	has_one :libauxdet, as: :libauxdetable
	before_create :crea_lib_aux
	before_update :actualiza_name_lib_aux
	accepts_nested_attributes_for :libauxdet, allow_destroy: true

    def fullname
    	if self.esjuridica
    		self.Nombres.strip
        else
        	[self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
    	end
    end
    
	def crea_lib_aux
	    if self.esjuridica
	 		build_libauxdet(:name => self.Nombres.strip)
	 	else
	 		build_libauxdet(:name => [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip)
	 	end
	end

	def actualiza_name_lib_aux
		if self.esjuridica
			libauxdet.name = self.Nombres.strip
		else
			self.libauxdet.name = [self.Appaterno, self.Apmaterno, self.Nombres].join(" ").strip
		end
	end	
end
