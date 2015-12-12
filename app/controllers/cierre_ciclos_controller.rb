class CierreCiclosController < ApplicationController
  before_action :set_cierre_ciclo, only: [:show, :edit, :update, :destroy]

  # GET /cierre_ciclos
  # GET /cierre_ciclos.json
  def index
    @cierre_ciclos = CierreCiclo.all
  end

  # GET /cierre_ciclos/1
  # GET /cierre_ciclos/1.json
  def show
  end

  # GET /cierre_ciclos/new
  def new
    @cierre_ciclo = CierreCiclo.new
    @cierre_ciclo.fechaproceso = Ciclo.fecha_cierre(1)
    @cierre_ciclo.ciclo_id = Ciclo.id_ciclo_cierre(1)
    @cierre_ciclo.empresa_id = 1
    @cierre_ciclo.activo = true
  end

  # GET /cierre_ciclos/1/edit
  def edit
  end

  # POST /cierre_ciclos
  # POST /cierre_ciclos.json 
  def create
    @cierre_ciclo = CierreCiclo.new(cierre_ciclo_params)

    respond_to do |format|
      if @cierre_ciclo.save
        #format.html { redirect_to @cierre_ciclos_url, notice: 'Cierre ciclo was successfully created.' }
        format.html { redirect_to action: "index", notice: 'Cierre de Ciclo fue creado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @cierre_ciclo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cierre_ciclos/1
  # PATCH/PUT /cierre_ciclos/1.json
  def update
    respond_to do |format|
      if @cierre_ciclo.update(cierre_ciclo_params)
        format.html { redirect_to @cierre_ciclo, notice: 'Cierre ciclo was successfully updated.' }
        format.json { render :show, status: :ok, location: @cierre_ciclo }
      else
        format.html { render :edit }
        format.json { render json: @cierre_ciclo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cierre_ciclos/1
  # DELETE /cierre_ciclos/1.json
  def destroy
    @cierre_ciclo.destroy
    respond_to do |format|
      format.html { redirect_to cierre_ciclos_url, notice: 'Cierre ciclo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def datatable
    render json: CierreCiclosDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cierre_ciclo
      @cierre_ciclo = CierreCiclo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cierre_ciclo_params
      params.require(:cierre_ciclo).permit(:fechaproceso, :desc, :activo, :empresa_id, :tc, :esoficial, :ciclo_id)
    end
end
