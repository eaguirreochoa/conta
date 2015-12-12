class Diariodet < ActiveRecord::Base
	belongs_to :catalogo
	belongs_to :oficina
	belongs_to :fondo
	belongs_to :moneda
	belongs_to :user
  belongs_to :libauxdet
	delegate :codigo, to: :catalogo, prefix: true, allow_nil: true #en la vista carga la el codigo de cuenta
	#delegate :Sigla, to: :oficina, prefix: true, allow_nil: false

	#before_create :set_monto

	validate :val_atributos
	#attr_accessible :monto

	def val_atributos
		if self.catalogo_id.blank?
     		errors.add(:catalogo_id, "Item \##{self.item} Debe seleccionar una cuenta contable")
    	end    	
    	if self.debeori == 0 && self.haberori == 0
     		errors.add(:debeori, "Item \##{self.item} Debe digitar un monto en el debe o haber")
    	end
 	end
 
  def lista_laux 
    c = CuentaConfig.new(self.catalogo_id)    
    return c.libro_aux1
  end
  

 # 	def es_deudor
 #    #puts "valor es es_deudor funcion"
 #    #puts self.debeori
 #  	if self.debeori != 0
 #  		return true
 #  	else	
 #  	 return false
 #  	end
 #  end

      

  # 	def monto=( value )
 	# 	@monto = value
 	# end

  # 	def monto
  #  		if self.esdebito.blank?
	 #  		@monto = 0
  # 		else
  # 			if self.esdebito.to_s == true.to_s
  # 				@monto = self.debeori
  # 			else
		# 		@monto = self.haberori
  # 			end
  # 		end 

  # 	end
    
	# def haber_debe=( value )
 #  	@haber_debe = value
 #  end

 #   	#setea campo debeori y haberori
 #  def set_monto
 #   	self.debeori = 0
 #    self.haberori = 0

 #    if @haber_debe.to_s ==  Catalogo::NATURALEZA[:debe].to_s
 #    	self.debeori = @monto
 #    else
	# 		self.haberori = @monto
 #    end
 #  end 
 	# def set_monto
 	# 	puts "detalle"
 	# 	puts self.debe
 	# end

end
