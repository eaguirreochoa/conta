require 'test_helper'

class LogearYAccederTest < ActionDispatch::IntegrationTest
  fixtures :users
  def setup
	 @adm = users(:eaguirre)
	 @adm_pw = '1224'
  end
  
  test "valida_clave" do
  	#si el password es el correcto
	  assert @adm.valid_password?(@adm_pw), "'#{@adm_pw}' la contraseña del administrador no es valido"
  end

  test "administrador_inicia_sesion_con_clave_correcta" do
	 post_via_redirect '/users/sign_in', 'user[username]' => @adm.username, 'user[password]' => @adm_pw
	 #si tuvo exito el logeo
	 assert_equal '/welcome', path
  end
end
