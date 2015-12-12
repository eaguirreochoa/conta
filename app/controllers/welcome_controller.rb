class WelcomeController < ApplicationController
  def index
  	respond_to do |format|
    	format.html { redirect_to diarios_url, notice: 'Ha iniciado sesión satisfactoriamente.' }
    end 
  end
end
