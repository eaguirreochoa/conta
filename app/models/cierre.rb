class Cierre < ActiveRecord::Base
  belongs_to :user
  TIPO = {:PERIODO => 1, :CICLO => 2}
  validate :verifica_creacion_del_cierre, on: :create
  validate :verifica_anulacion_del_cierre, on: :update
  before_create :nuevo_cierra_periodo
  before_update :modificar_inactiva_cierre
  after_initialize :set_estado_inicial

  #set_estado_inicial
  def set_estado_inicial
    self.tipo ||= Cierre::TIPO[:PERIODO]
    self.fechaproceso ||= Periodo.fecha_proximo_cierre(1)
    self.periodo_id ||= Periodo.idperiodo_proximo_cierre(1)
    self.empresa_id ||= 1
    self.activo ||= true
  end
  	#valida fecha a cerrar
	def verifica_creacion_del_cierre
    if self.periodo_id == 0 
      errors.add(:fechaproceso, "No existen periodos para cerrar.")
      return
    end

		if self.fechaproceso.to_date.strftime("%Y/%m/%d") < Periodo.fecha_proximo_cierre(1).to_date.strftime("%Y/%m/%d")
    		errors.add(:fechaproceso, "La fecha seleccionada ya fue cerrada.")
    	else
    		if self.fechaproceso.to_date.strftime("%Y/%m/%d") != Periodo.fecha_proximo_cierre(1).to_date.strftime("%Y/%m/%d")
    			errors.add(:fechaproceso, "Existen fechas anteriores que aun no fueron cerradas.")
    		end
    	end    
	end
  #valida fecha de anular el cierre
  def verifica_anulacion_del_cierre
    if Cierre.where("fechaproceso > ? and activo = ?  and empresa_id = ? ", self.fechaproceso.to_date + 1.day, true, 1).exists?
      errors.add(:fechaproceso, "Existen fechas posteriores que estan cerradas.")
    end
  end

	def nuevo_cierra_periodo
    #cambia a estado A:aprobado los comprobantes del periodo a cerrar
		Diario.where("fechacbte between ? and ?", Periodo.fecha_ini_periodo(self.empresa_id).to_date, Periodo.fecha_fin_periodo(self.empresa_id).to_date + 1.day).update_all(estado: 'A')
    #inactiva el periodo que se esta cerrando
		Periodo.find_by(id: self.periodo_id).update(activo: false)
    self.desc = self.desc.capitalize		
	end

  def modificar_inactiva_cierre
    fechas = Periodo.find_by(id: self.periodo_id)
    Diario.where("fechacbte between ? and ?", fechas.fini.to_date, fechas.ffin.to_date + 1.day).update_all(estado: 'F')
    Periodo.find_by(id: self.periodo_id).update(activo: true)
  end

end
