class Periodo < ActiveRecord::Base
  belongs_to :empresa
  
  def self.id_periodo(fecha, idempresa)
  	periodos = Periodo.select(:id).where("? BETWEEN fini and ffin and empresa_id = ?", fecha.to_date.beginning_of_day, idempresa)
  	id = 0

    periodos.each do |p|
    	id = p.id
  	end

  	return id
  end

  def self.nro_periodo(fecha)
  	periodos = Periodo.select(:nro).where("? BETWEEN fini and ffin", fecha.to_date.beginning_of_day)
  	nro = 0

    periodos.each do |p|
    	nro = p.nro
  	end

  	return nro
  end

  def self.fecha_proximo_cierre(idempresa)
    fecha_fin_periodo(idempresa)
  end
  
  def self.fecha_ini_periodo(idempresa)
    idciclo = Ciclo.id_ciclo_cierre(idempresa)
    periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
    if Periodo.exists?(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo)
      fini= Periodo.find_by(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo).fini
    else 
      fini = nil
    end
    
    return fini
  end

  def self.fecha_fin_periodo(idempresa)
    idciclo = Ciclo.id_ciclo_cierre(idempresa)
    #periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
    if Periodo.exists?(activo: true, empresa_id: idempresa, ciclo_id: idciclo)
      periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
      ffin= Periodo.find_by(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo).ffin
    else 
      ffin = nil
    end
    
    return ffin
  end

  def self.fecha_fin_periodo_rpt(idempresa)
    idciclo = Ciclo.id_ciclo_cierre(idempresa)
    #periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
    if Periodo.exists?(activo: true, empresa_id: idempresa, ciclo_id: idciclo)
      periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
      ffin= Periodo.find_by(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo).ffin
    else 
      ffin = Time.now
    end
    
    return ffin
  end


  def self.idperiodo_proximo_cierre(idempresa)
    idciclo = Ciclo.id_ciclo_cierre(idempresa)
    periodo = Periodo.where(activo: true, empresa_id: idempresa, ciclo_id: idciclo).minimum(:nro)
    if Periodo.exists?(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo)
      id= Periodo.find_by(activo: true, empresa_id: idempresa, nro: periodo, ciclo_id: idciclo).id  
    else
      id = 0
    end  
    return id
  end

  def self.todos_los_periodos_cerrados(idempresa, idciclo)
    if Periodo.exists?(activo: true, empresa_id: idempresa, ciclo_id: idciclo)
      return false
    else
      return true
    end
  end
end
