class Catalogo < ActiveRecord::Base

  #multiplicidad para las asociaciones
  belongs_to :nivel
  belongs_to :grupo
  #has_many :hijos, class_name: "Catalogo", foreign_key: "padre"   
  belongs_to :papa, class_name: "Catalogo"
  belongs_to :libroauxiliar, class_name: "Catalogo", foreign_key: "padre_id"

  #enumerador 
  NATURALEZA = {:debe => false, :haber => true }

  ID_CTA_UTIL_PER = 694
  ID_CTA_UTIL_PER_ACUM = 693
  ID_CTA_AJUSTE_DIF_CAMBIO = 709

  #callback antes de crear al objeto catalogo
  before_create :gen_codigo, :gen_naturaleza, :gen_estransac

  #callback antes de guardar al objeto catalogo
  before_save :set_aux

  #valida atributos necesarios para la creacion del objeto catalogo
  validate :val_attr

  #composicion para la generacion del la secuencia del codigo sugerido para la cuenta
  composed_of :cuenta,
  :class_name => "CuentaCo",
  :mapping => [%w(id idcuenta)]

  #composicion para recuperar la configuracion del libro auxiliar, moneda..
  composed_of :cuenta_config,
  :class_name => "CuentaConfig",
  :mapping => [%w(id idcuenta)]

  #Valida la existencia de los atributos del modelo q son oblegatorios
  def val_attr
    if (self.nombre.blank?)
        errors.add(:nombre, "Debe ingresar el nombre de la cuenta")
    end

    # if (self.codigo.blank?)
    #     errors.add(:codigo, "Debe ingresar un codigo valido")
    # end

    # if (self.padre.blank?)
    #     errors.add(:padre, "Debe seleccionar un padre de la cuenta")
    # end

    # if (self.nivel_id.blank?)
    #     errors.add(:nivel_id, "Debe seleccionar un nivel valido")
    # end

    # if (self.grupo_id.blank?)
    #     errors.add(:grupo_id, "Debe seleccionar un grupo valido")
    # end
  end

  
  # def codigo
  #   if not(self.codigo.blank?)
  #     n = Nivel.find_by(id: self.nivel_id).nrodigitos
  #     self.codigo.last(n)
  #   end 
  # end

  # def format_codigo(pcodigo)
  #    puts pcodigo
  #   if pcodigo.blank?
  #     return ""
  #   else
  #     n = Nivel.find_by(id: self.nivel_id).nrodigitos
  #     return pcodigo.last(n)
  #   end 
  # end

  # def sigla
  #   if self.sigla.blank?
  #     return ""
  #   else
  #     n = Nivel.find_by(id: self.nivel_id).nrodigitos
  #     nn = Nivel.find_by(id: self.nivel_id).nrodigitostotal
  #     return self.codigo.reverse.last(nn-n).reverse
  #   end 
  # end

  def self.listar_usa_laux1
    where(usalaux1: true, activo: true)
  end

  #codigo de la cuenta mas el nombre
  def codigoname
    [self.codigo, self.nombre].join(" ")
  end

  #nivel de la cuenta ya sea edicion o nueva: por default el nivel mas profundo
  def nivel_default
    if self.nivel_id.blank? 
      Nivel.nivel_transac 
    else
      self.nivel_id
    end 
  end
  
  #codigo de cuenta contable: codigo_padre + caracteres_del_nivel
  def gen_codigo
    #puts "ini gen_codigo"
    if self.nivel_id != 1
      codigo = Catalogo.find_by(id: self.padre_id).codigo
      self.codigo = codigo.to_s + self.sigla.to_s
    end
  end 

  #setea valores por default antes de persistencia
  def set_aux
    if self.tlaux1.blank?
      self.usalaux1 = false
      self.tlaux1 = "0"
    else
      self.usalaux1 = true
    end
    if self.tlaux2.blank?
      self.usalaux2 = false
      self.tlaux2 = "0"
    else
      self.usalaux2 = true
    end

    if self.idctaajusteufv.blank?
      self.idctaajusteufv = 0
    end
    if self.idctaajustetc.blank?
      self.idctaajustetc = 0
    end
  end

  #codigo de la naturaleza de la cuenta contable: (D deudora) o (A acreedora)
  def gen_naturaleza
    self.naturaleza = Grupo.find_by(id: self.grupo_id).naturaleza.to_s
  end

  #si la cuenta contable en cuestion es transaccional
  def gen_estransac
    if Nivel.nivel_transac == self.nivel_id.to_i
      self.estransaccional = true
    else 
      self.estransaccional = false
    end
  end
  #return id del libro aux, sino tiene devuelve vacio
  def self.id_lib_aux(nro, idcuenta)
    catalogo = Catalogo.find_by(id: idcuenta)
    if nro == 1 
      if catalogo.usalaux1
        return catalogo.tlaux1
      else
        return ""
      end #catalogo.usalaux1
    else
      if catalogo.usalaux2
       
        return catalogo.tlaux2
      else
        return ""
      end #catalogo.usalaux2
    end #nro == 1 
  end #self.id_lib_aux(nro, idcuenta)

  
end


