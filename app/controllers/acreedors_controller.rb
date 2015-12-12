class AcreedorsController < ApplicationController
  before_action :set_acreedor, only: [:show, :edit, :update, :destroy]

  # GET /acreedors
  # GET /acreedors.json
  def index
    @acreedors = Acreedor.all
  end

  # GET /acreedors/1
  # GET /acreedors/1.json
  def show
  end

  # GET /acreedors/new 
  def new
    @acreedor = Acreedor.new
    if params[:id_tipo].to_i == 1
      @acreedor.esjuridica = false 
    else
      @acreedor.esjuridica = true
    end
    load_Obj
  end

  # GET /acreedors/1/edit
  def edit
    load_Obj
  end

  # POST /acreedors
  # POST /acreedors.json
  def create
    @acreedor = Acreedor.new(acreedor_params)
    respond_to do |format|
      if @acreedor.save
        format.html { redirect_to @acreedor, notice: 'Acreedor was successfully created.' }
        format.json { render :show, status: :created, location: @acreedor }
        format.js
      else
        format.html { render :new }
        format.json { render json: @acreedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acreedors/1
  # PATCH/PUT /acreedors/1.json
  def update
    respond_to do |format|
      if @acreedor.update(acreedor_params)
        format.html { redirect_to @acreedor, notice: 'Acreedor was successfully updated.' }
        format.json { render :show, status: :ok, location: @acreedor }
      else
        format.html { render :edit }
        format.json { render json: @acreedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acreedors/1
  # DELETE /acreedors/1.json
  def destroy
    @acreedor.destroy
    respond_to do |format|
      format.html { redirect_to acreedors_url, notice: 'Acreedor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def datatable
    render json: AcreedorsDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acreedor
      @acreedor = Acreedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acreedor_params
      params.require(:acreedor).permit(:Nombres, :Appaterno, :Apmaterno, :Apcasada, :Di, :Telefono, :Correo, :Oficina_id, :Cargo_id, :Dociden_id, :fechaingreso, :fechanacimiento, :genero, :estadocivil, :tiposociedad_id, :tipoentidad_id, :esjuridica, libauxdet_attributes: [:id, :name] )
    end

    def load_Obj
      if @acreedor.esjuridica
        @dis = Dociden.select(:Sigla, :id).where("Codigo = ? AND Activo = ?", "NIT", true)
        #@dis = Dociden.all
        @tiposociedads = Tiposociedad.all
        @tipoentidads = Tipoentidad.all
      else
        @dis = Dociden.all
        @diexs = Docidenext.all
      end
    end


   
end #class AcreedorsController < ApplicationController
