class Diario < ActiveRecord::Base
  belongs_to :origenasiento
  belongs_to :tipocomprobante
  belongs_to :empresa
  has_many :diariodets, foreign_key: "diario_id"
  has_one :correlcbte

  accepts_nested_attributes_for :diariodets,:correlcbte, allow_destroy: true

  before_save :actualiza_atributos_diariodets
  before_create :actualiza_nro_comprobante

  validates :empresa_id, :tipocomprobante_id, :tc, :glosagral,  :presence => {message: "No puede dejarse vacío"}
  validate :fecha_comprobante

  validates_associated :diariodets

  
  #accepts_nested_attributes_for :correlcbte, allow_destroy: true
  
  # attr_accessible :monto, :naturaleza

  #def diariodets_for_form
  #  collection = diariodets.where(diario_id: id)
  #  collection.any? ? collection : diariodets.build 
  #end
  
  def fecha_comprobante
    if self.tipocomprobante_id == 1 #solo para el comprobante manual verifica?
      if self.fechacbte.to_date < Periodo.fecha_ini_periodo(1).to_date
        errors.add(:fechacbte, "La fecha corresponde a un periodo cerrado.")
      end
    end
  end

def codigo  
  [self.tipocomprobante.sigla, self.nrocbte].join("-")
end
  

  # def anular
  #   self.esaunlado  = true    
  # end

  # def self.nro_cbte(idempresa, idtipocbte, idperiodo)
  #   n = Correlcbte.where(:empresa_id => idempresa, :tipocomprobante_id => idtipocbte, :periodo_id => idperiodo, :activo => true ).maximum(:nro)

  #   if n.blank?
  #     #puts "no encuentra correlativo nuulo"
  #     n = 1
  #   else
  #     n = n + 1
  #   end

  #   return n
  # end

              
  def actualiza_atributos_diariodets    
    sum_debe = 0
    sum_haber = 0
    sum_debe_sec = 0
    sum_haber_sec = 0
    item_max = 0
    idcuenta_ajuste_dif_cambio = 709 #Catalogo.find_by(id: Catalogo::ID_CTA_AJUSTE_DIF_CAMBIO)

    set_datos_segun_conf

    if self.origenasiento_id == 1 # si es manual actualiza columnas debe, haber...
        diariodets.each do |child|       
          if child.ajuste.blank?  or child.ajuste == '0'
            cod_moneda_trasac = Moneda.find_by(id:child.moneda_id).codigo 
            child.tcori = self.tc
            child.ajuste = '0'            
            if cod_moneda_trasac == Moneda::CODIGO_SYS[:nal]
              child.debe = (child.debeori).round(2)  
              child.haber = (child.haberori).round(2)  
              child.debesec = (child.debeori/Conta::TCV_CONST).round(2) 
              child.habersec = (child.haberori/Conta::TCV_CONST).round(2) 
              child.tcsec = child.tcori
            else
              if cod_moneda_trasac == Moneda::CODIGO_SYS[:sec]
                tc_transac = 0
                if Conta::TCV_CONST != child.tcori
                  tc_transac = child.tcori
                else
                  tc_transac = Conta::TCV_CONST
                end
                child.tcsec = tc_transac

                child.debe = (child.debeori*tc_transac).round(2)  
                child.haber = (child.haberori*tc_transac).round(2)  

                child.debesec = (child.debeori).round(2) 
                child.habersec = (child.haberori).round(2) 
              end #cod_moneda_trasac = Moneda::CODIGO_SYS[:sec]
            end #cod_moneda_trasac = Moneda::CODIGO_SYS[:nal]
            if item_max < child.item
              item_max = child.item
            end            
            sum_debe = sum_debe + child.debe
            sum_haber = sum_haber + child.haber
            sum_debe_sec = sum_debe_sec + child.debesec
            sum_haber_sec = sum_haber_sec + child.habersec
          end #if child.ajuste.blank?  or child.ajuste == '0'
        end #end diariodets.each do |child|

          ###
          ###cuadre global
      if (sum_debe != sum_haber) or (sum_debe_sec != sum_haber_sec)
        ajuste = 0
        ajuste_sec = 0      
        ajuste = sum_debe - sum_haber
        ajuste_sec = sum_debe_sec - sum_haber_sec  
        if ajuste != 0 
          if ajuste > 0
            item_max = item_max + 1
            diariodets.build(:item => item_max, :catalogo_id => idcuenta_ajuste_dif_cambio, :tlaux1 => "0", :tlaux2 => "0", :codtlaux1 => "", :codtlaux2 => "", :debe => 0, :haber => ajuste, :debesec => 0, :habersec => 0, :debeori => 0, :haberori => ajuste, :tcori => self.tc, :glosa => 'AJUSTE AUTOMATICO POR CUADRE', :esdebito => false, :monto => ajuste, :ajuste => "1", :oficina_id => Oficina.id_oficina_nacional, :libauxdet_id => 0, :moneda_id => 1)
          else
            ajuste = ajuste * (-1)
            item_max = item_max + 1
            diariodets.build(:item => item_max, :catalogo_id => idcuenta_ajuste_dif_cambio, :tlaux1 => "0", :tlaux2 => "0", :codtlaux1 => "", :codtlaux2 => "", :debe => ajuste, :haber => 0, :debesec => 0, :habersec => 0, :debeori => ajuste, :haberori => 0, :tcori => self.tc, :glosa => 'AJUSTE AUTOMATICO POR CUADRE', :esdebito => false, :monto => ajuste_sec, :ajuste => "1", :oficina_id => Oficina.id_oficina_nacional, :libauxdet_id => 0, :moneda_id => 1)
          end#end ajuste > 0
        end# end ajuste != 0 
        if ajuste_sec != 0
          if ajuste_sec > 0
            item_max = item_max + 1
            diariodets.build(:item => item_max, :catalogo_id => idcuenta_ajuste_dif_cambio, :tlaux1 => "0", :tlaux2 => "0", :codtlaux1 => "", :codtlaux2 => "", :debe => 0, :haber =>0 , :debesec => 0, :habersec => ajuste_sec, :debeori => 0, :haberori => ajuste_sec, :tcori => self.tc, :glosa => 'AJUSTE AUTOMATICO POR CUADRE', :esdebito => false, :monto => ajuste_sec, :ajuste => "1", :oficina_id => Oficina.id_oficina_nacional, :libauxdet_id => 0, :moneda_id => 2)
          else
            ajuste_sec = ajuste_sec * (-1)
            item_max = item_max + 1
            diariodets.build(:item => item_max, :catalogo_id => idcuenta_ajuste_dif_cambio, :tlaux1 => "0", :tlaux2 => "0", :codtlaux1 => "", :codtlaux2 => "", :debe => 0, :haber => 0, :debesec => ajuste_sec, :habersec => 0, :debeori => ajuste_sec, :haberori => 0, :tcori => self.tc, :glosa => 'AJUSTE AUTOMATICO POR CUADRE', :esdebito => false, :monto => ajuste_sec, :ajuste => "1", :oficina_id => Oficina.id_oficina_nacional, :libauxdet_id => 0, :moneda_id => 2)    
          end#end ajuste_sec > 0
        end# end ajuste_sec != 0     
      end #(sum_debe != sum_haber) or (sum_debe_sec != sum_haber_sec)
    end#if self.tipocomprobante_id != 5 # si es automatico no aplica lo siguiente      
  end # end actualiza_atributos_diariodets   

def actualiza_nro_comprobante
  idperiodo = Periodo.id_periodo(self.fechacbte.to_date, self.empresa_id)
  nro_comprobante = Correlcbte.nro_cbte(self.empresa_id, self.tipocomprobante_id, self.fechacbte.to_date)
  self.nrocbte = nro_comprobante
  build_correlcbte(:nro => nro_comprobante, :tipocomprobante_id => self.tipocomprobante_id, :empresa_id => self.empresa_id, :periodo_id => idperiodo, :activo => true)  
end

def set_datos_segun_conf
  diariodets.each do |child|
    self.glosagral = self.glosagral
    child.glosa = self.glosagral
    c = Catalogo.find_by(id: child.catalogo_id) 
    child.tlaux1 = c.tlaux1
    child.tlaux2 = c.tlaux2

    if c.naturaleza == "D" 
      child.esdebito = true
    else
      child.esdebito = false
    end#if c.naturaleza == "D" 

    if child.tlaux1 == 0
      child.codtlaux1 = ""
      child.codtlaux2 = ""
      child.tlaux2 = 0
      child.libauxdet_id = 0
    else
      child.codtlaux1 = child.libauxdet_id
    end #child.tlaux1 == 0

  end #diariodets.each do |child|
end #set_datos_segun_conf
end #end class

