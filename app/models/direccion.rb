class Direccion < ActiveRecord::Base
  belongs_to :Empleado, foreign_key: "Persona_id"
  belongs_to :ubigeo, class_name: "Ubicaciongeografica", foreign_key: "Ubicaciongeografica_id"
  #accepts_nested_attributes_for :Ubicaciongeografica
  delegate :departamento, :provincia, to: :ubigeo, prefix: true, allow_nil: true
  

  #delegate :Codigodept, :Codigoprov, :Codigoloca, to: :Ubicaciongeografica
  # def departamento_id
  # 	@departamento_id
  # end
  # def provincia_id
  # 	@provincia_id
  # end
  # def localidad_id
  # 	@localidad_id
  # end
end
