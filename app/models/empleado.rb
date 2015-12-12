class Empleado < Persona
	belongs_to :Oficina
	belongs_to :Cargo
  belongs_to :Dociden
  has_many :Direccions, foreign_key: "Persona_id"
  before_create :set_datos_por_defecto
  HESTADOCIVIL = {'C' => 'Casado(a)', 'D' => 'Divorciado(a)', 'E' => 'Separado(a)', 'S' => 'Soltero(a)', 'U' => 'Unión Libre', 'V' => 'Viudo(a)' }
  HGENERO = {true => 'Masculino', false => 'Femenino'}
 
  accepts_nested_attributes_for :Direccions, allow_destroy: true
  validates :Nombres, :Di, :Telefono, :Correo, :presence => {message: "No puede dejarse vacío"}
  validate :val_vars
  

    protected

    def set_datos_por_defecto
      self.esjuridica = 'f'
    end

    # def validate
    #     #errors.add(:price, "Must be at least 0.01") if price.nil? || price < 0.01
    #     puts "apellido paterno=="
    #     puts self.Appaterno
    #     puts self.Nombres
    #     puts self.Appaterno.blank?
    #     if self.Appaterno.blank?
    #       errors.add(:Appaterno, "Debe ingresar el apellido paterno") 
    #     end
    # end
    def val_vars
      if (self.Apcasada.blank? && self.estadocivil == 'C' )
        errors.add(:Apcasada, "Debe ingresar el apellido de casado(a)")
      end
      if self.fechanacimiento == nil
        errors.add(:fechanacimiento, "Debe registrar la fecha de nacimiento")
      end

      if (self.fechanacimiento != nil && ((Time.now.to_date - self.fechanacimiento.to_date).to_i < (365 *18)))       
        #puts (Time.now.to_date - self.fechanacimiento.to_date).to_i
        errors.add(:fechanacimiento, "No puede registrar a un menor de edad")
      end

      if (self.fechanacimiento != nil && ((Time.now.to_date - self.fechanacimiento.to_date).to_i > (365 *80)))       
        errors.add(:fechanacimiento, "No puede registrar a personas mayores de 80")
      end

      if self.fechaingreso == nil
        errors.add(:fechaingreso, "Debe registrar la fecha de ingreso")
      end

      if (self.fechaingreso != nil && ((Time.now.to_date - self.fechaingreso.to_date).to_i < 0))       
        errors.add(:fechaingreso, "La fecha de ingreso no puede ser mayor a la fecha actual")
      end
    end

end