class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = Cliente.all
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
    if params[:id_tipo].to_i == 1
      @cliente.esjuridica = false 
    else
      @cliente.esjuridica = true
    end
    load_Obj
  end

  # GET /clientes/1/edit
  def edit
      load_Obj
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: 'Cliente was successfully created.' }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    respond_to do |format|
      if @cliente.update(cliente_params)
        format.html { redirect_to @cliente, notice: 'Cliente was successfully updated.' }
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    @cliente.destroy
    respond_to do |format|
      format.html { redirect_to clientes_url, notice: 'Cliente was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def datatable
    render json: ClientesDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:Nombres, :Appaterno, :Apmaterno, :Apcasada, :Di, :Telefono, :Correo, :Oficina_id, :Cargo_id, :Dociden_id, :fechaingreso, :fechanacimiento, :genero, :estadocivil, :tiposociedad_id, :tipoentidad_id, :esjuridica, libauxdet_attributes: [:id, :name] )
    end

    def load_Obj
      if @cliente.esjuridica
        @dis = Dociden.select(:Sigla, :id).where("Codigo = ? AND Activo = ?", "NIT", true)
        #@dis = Dociden.all
        @tiposociedads = Tiposociedad.all
        @tipoentidads = Tipoentidad.all
      else
        @dis = Dociden.all
        @diexs = Docidenext.all
      end
    end
end
