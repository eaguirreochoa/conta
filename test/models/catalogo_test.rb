require 'test_helper'

class CatalogoTest < ActiveSupport::TestCase
	#recupera los datos de prueba de catalogos.yml
	fixtures :catalogos
 
  test "validar_atributos" do
  	#cuenta_cont = Catalogo.new
  	#recupera los datos de prueba para el caso de prueba validar atributos
  	cuenta_cont = catalogos(:disponibilidades)
  	assert_not cuenta_cont.valid?, "Faltan atributos obligatorios para el new objeto del catalogo"
  	assert_not_equal ["Debe ingresar el nombre de la cuenta"], cuenta_cont.errors.messages[:nombre]
  end

  test "validar_secuencia_sugerida" do
  	#padre de la cuenta
  	cuenta_cont_padre = Catalogo.find_by(2)
  	#verifica secuencia sugeridad del siguiente hijo 
  	assert_equal(1, cuenta_cont_padre.cuenta.secuenciasugerida.to_i, 
                "La secuencia 1 no es igual a la sugerida #{cuenta_cont_padre.cuenta.secuenciasugerida}") 
  end

end
