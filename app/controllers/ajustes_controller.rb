class AjustesController < ApplicationController
  before_action :set_ajuste, only: [:show, :edit, :update, :destroy]

  # GET /ajustes
  # GET /ajustes.json
  def index
    @ajustes = Ajuste.all
  end

  # GET /ajustes/1
  # GET /ajustes/1.json
  def show
  end

  # GET /ajustes/new 
  def new
    @ajuste = Ajuste.new
    @ajuste.fechaproceso = @ajuste.periodo_a_procesar
    @ajuste.indiceant = @ajuste.ultimo_indice_procesado
  end

  # GET /ajustes/1/edit
  def edit
  end

  # POST /ajustes
  # POST /ajustes.json
  def create
    @ajuste = Ajuste.new(ajuste_params)

    respond_to do |format|
      if @ajuste.save
        format.html { redirect_to @ajuste, notice: 'Ajuste was successfully created.' }
        format.json { render :show, status: :created, location: @ajuste }
      else
        format.html { render :new }
        format.json { render json: @ajuste.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ajustes/1
  # PATCH/PUT /ajustes/1.json
  def update
    respond_to do |format|
      if @ajuste.update(ajuste_params)
        format.html { redirect_to @ajuste, notice: 'Ajuste was successfully updated.' }
        format.json { render :show, status: :ok, location: @ajuste }
      else
        format.html { render :edit }
        format.json { render json: @ajuste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ajustes/1
  # DELETE /ajustes/1.json
  def destroy
    @ajuste.destroy
    respond_to do |format|
      format.html { redirect_to ajustes_url, notice: 'Ajuste was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def datatable
    render json: AjustesDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ajuste
      @ajuste = Ajuste.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ajuste_params
      params.require(:ajuste).permit(:tipo, :fechaproceso, :indiceant, :indiceact, :activo)
    end
end
