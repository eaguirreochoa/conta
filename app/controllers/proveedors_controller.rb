class ProveedorsController < ApplicationController
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]

  # GET /proveedors
  # GET /proveedors.json
  def index
    @proveedors = Proveedor.all
  end

  # GET /proveedors/1
  # GET /proveedors/1.json
  def show
  end

  # GET /proveedors/new
  def new
    @proveedor = Proveedor.new
    if params[:id_tipo].to_i == 1
      @proveedor.esjuridica = false 
    else
      @proveedor.esjuridica = true
    end
    load_Obj
  end

  # GET /proveedors/1/edit
  def edit
    load_Obj
  end

  # POST /proveedors
  # POST /proveedors.json
  def create
    @proveedor = Proveedor.new(proveedor_params)

    respond_to do |format|
      if @proveedor.save
        format.html { redirect_to @proveedor, notice: 'Proveedor was successfully created.' }
        format.json { render :show, status: :created, location: @proveedor }
      else
        format.html { render :new }
        format.json { render json: @proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proveedors/1
  # PATCH/PUT /proveedors/1.json
  def update
    respond_to do |format|
      if @proveedor.update(proveedor_params)
        format.html { redirect_to @proveedor, notice: 'Proveedor was successfully updated.' }
        format.json { render :show, status: :ok, location: @proveedor }
      else
        format.html { render :edit }
        format.json { render json: @proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proveedors/1
  # DELETE /proveedors/1.json
  def destroy
    @proveedor.destroy
    respond_to do |format|
      format.html { redirect_to proveedors_url, notice: 'Proveedor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def datatable
    render json: ProveedorsDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @proveedor = Proveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proveedor_params
      params.require(:proveedor).permit(:Nombres, :Appaterno, :Apmaterno, :Apcasada, :Di, :Telefono, :Correo, :Oficina_id, :Cargo_id, :Dociden_id, :fechaingreso, :fechanacimiento, :genero, :estadocivil, :tiposociedad_id, :tipoentidad_id, :esjuridica, libauxdet_attributes: [:id, :name] )
    end

    def load_Obj
      if @proveedor.esjuridica
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
