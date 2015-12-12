class EmpleadosController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @empleados = Empleado.all
  end

  def new
    @empleado = Empleado.new()
    # @cargos = Cargo.all
    # @oficinas = Oficina.all
    # @dis = Dociden.all
    # @diexs = Docidenext.all
    # @departamentos = Ubicaciongeografica.select(:Codigodept,:Nombredept).distinct
    # @provincias = Ubicaciongeografica.select(:Codigoprov,:Nombreprov).distinct
    # @localidades = Ubicaciongeografica.select(:id,:Nombreloca).distinct
    load_Obj
    @empleado.Direccions.build(:Ubicaciongeografica_id => 1)
   
  end

  def create
    @empleado = Empleado.new(empleado_params)   

    respond_to do |format|
      if @empleado.save
        format.html { redirect_to @empleado, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @empleado }
      else 
        load_Obj
        format.html { render action: 'new' }
        format.json { render json: @empleado.errors, status: :unprocessable_entity }
      end
    end  
    #@empleado.Direccions.each do |d| 
    #  d.Ubicaciongeografica_id = Ubicaciongeografica.find_by(Codigoloca: empleado_params[:Direccions_attributes]['0'][:Ubicaciongeografica_id]).id      
    #end

    # begin
    #   if @empleado.save
    #     render :index
    #   end      
    # rescue Exception => e
    #   puts e.message
    #   puts e.backtrace.inspect
    # end
  end

 


  # GET /users/1/edit
  def edit
    # @cargos = Cargo.all
    # @oficinas = Oficina.all
    # @dis = Dociden.all
    # @diexs = Docidenext.all
    # @departamentos = Ubicaciongeografica.select(:Codigodept,:Nombredept).distinct
    # @provincias = Ubicaciongeografica.select(:Codigoprov,:Nombreprov).distinct
    # @localidades = Ubicaciongeografica.select(:id,:Nombreloca).distinct
    load_Obj

    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def update
    #puts"EXTENCION DEL DOCUMENTO DE ID:=="
    #puts params[:post][:docidenexts_id]
    #puts params[:id]
    #@empleado = Empleado.find_by(id:params[:id]) 
    #empleado_params[:Di]=empleado_params[:Di]
    respond_to do |format|
      if @empleado.update_attributes(empleado_params)
       
        format.html { redirect_to @empleado, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @empleado }
      else
     
        load_Obj
        format.html { render action: 'edit' }
        format.json { render json: @empleado.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_povincia
    @provincias = Ubicaciongeografica.select(:Codigoprov,:Nombreprov).distinct.where("Codigodept = ?", params[:Codigodept])
    #@provincias = Ubicaciongeografica.select(:Codigoprov,:Nombreprov).distinct
    respond_to do |format|
      format.js
    end
  end

  def update_localidad
    @localidades = Ubicaciongeografica.select(:id,:Nombreloca).distinct.where("Codigoprov = ?", params[:Codigoprov])
    respond_to do |format|
      format.js
    end
  end

  def datatable_ajax 
    render json: EmpleadosDatatable.new(view_context) 
  end 


  private

  def empleado_params
    params.require(:empleado).permit(:Nombres, :Appaterno, :Apmaterno, :Apcasada, :Di, :Telefono, :Correo, :Oficina_id, :Cargo_id, :Dociden_id, :fechaingreso, :fechanacimiento, :genero, :estadocivil, Direccions_attributes: [:id, :Zonaurbana, :Edificio, :Pisodepof, :Descripcion, :Ubicaciongeografica_id])
  end

  def load_Obj
    @cargos = Cargo.all
    @oficinas = Oficina.all
    @dis = Dociden.all
    @diexs = Docidenext.all
    @departamentos = Ubicaciongeografica.select(:Codigodept,:Nombredept).distinct
    @provincias = Ubicaciongeografica.select(:Codigoprov,:Nombreprov).distinct
    @localidades = Ubicaciongeografica.select(:id,:Nombreloca).distinct      
  end

end
