class Ciclo < ActiveRecord::Base
  belongs_to :empresa
  has_many :periodos
  accepts_nested_attributes_for :periodos, allow_destroy: true
  TIPO = {:ED => "ENERO-DICIEMBRE", :AM => "ABRIL-MARZO", :JJ => "JULIO-JUNIO", :OS => "OCTUBRE-SEPTIEMBRE"}
  validate :valida_apertura_new_ciclo, on: :create
  before_create :abc


  def self.fecha_cierre(idempresa)
    if Ciclo.exists?(activo: true, empresa_id: idempresa)
		fecha = Ciclo.where(empresa_id: idempresa, activo: true).minimum(:ffin)
	else
		fecha = Time.now
	end
	return fecha.to_date
  end

  def self.id_ciclo_cierre(idempresa)   
		fecha = Ciclo.where(empresa_id: idempresa, activo: true).minimum(:ffin)
    if Ciclo.exists?(empresa_id: idempresa, activo: true, ffin: fecha.to_date.beginning_of_day)
		  id = Ciclo.find_by(empresa_id: idempresa, activo: true, ffin: fecha.to_date.beginning_of_day).id
    else
      id = 0
    end
	  return id
  end

  #fecha del primer ciclo activo
  def self.fecha_ini_ciclo(idempresa)
    idciclo = id_ciclo_cierre(idempresa)
    fini= Ciclo.find_by(id: idciclo).fini    
    return fini
  end

  #fecha del primer ciclo activo
  def self.fecha_fin_ciclo(idempresa)
    idciclo = id_ciclo_cierre(idempresa)
    ffin= Ciclo.find_by(id: idciclo).ffin    
    return ffin
  end

  def fini_sugerida(idempresa)
  
	if Ciclo.exists?(activo: true, empresa_id: idempresa)
		fecha = Ciclo.find_by(activo: true, empresa_id: idempresa).ffin + 1.day
	else
		fecha = Time.now
	end

	return fecha.strftime("%d/%m/%Y")
  end

  def valida_apertura_new_ciclo
  	a = Ciclo.select(1).where(empresa_id: 1, activo: true).count
  	if a.to_i >= 2
  		errors.add(:fini, "No puede existir mas de dos ciclos activos.")
  	end
  end

  def self.se_aperturo_new_ciclo(idempresa)
  	a = Ciclo.select(1).where(empresa_id: idempresa, activo: true).count
  	if a.to_i != 2
		  return false
  	else 
  		#verifica periodos
  		fecha = Ciclo.where(empresa_id: idempresa, activo: true).maximum(:fini)
		  id = Ciclo.find_by(empresa_id: idempresa, activo: true, fini: fecha.to_date.beginning_of_day).id
		  #puts "entro val"
		  #puts id
		  #puts Periodo.exists?(activo: true, empresa_id: idempresa, fini: fecha.to_date.beginning_of_day, ciclo_id: id)
		  if Periodo.exists?(activo: true, empresa_id: idempresa, fini: fecha.to_date.beginning_of_day, ciclo_id: id)
			 return true
		  else
			 return false
		  end
  	end
  end

  def crear_nuevos_periodos(tipo, fini)  		
  		c = []
  		if tipo == "ED"
  			i = 0
  			fini = fini.to_date
  			while i < 12 do
  				i +=1
  				#puts fini
  				a = Array.new(2)
				a[0] = fini.strftime("%Y/%m/%d")
				fini = fini + 1.month - 1.day
				a[1] = fini.strftime("%Y/%m/%d")
				fini = fini + 1.day
				c << a
			end
		end
		return c
		#return a
  end

  def ffin_ciclo(tipo, fini)
  	if tipo == "ED"
  		ffin = fini + 1.year - 1.day
  	end
  	return ffin
  end

  def abc
  	i = 0
  	crear_nuevos_periodos(self.tipo, self.fini).each do |a|
  		i += 1
  		periodos.build(fini: a[0].to_date ,ffin: a[1].to_date, nro: i ,gestion: a[0].to_date.year ,activo:true ,empresa_id: self.empresa_id)
  	end
  	self.ffin = ffin_ciclo(self.tipo, self.fini).to_date
  end
end
