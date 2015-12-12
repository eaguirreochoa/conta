class CierreCiclosDatatable
  delegate :params, :fa_icon, :link_to, :cierres_path, :edit_cierre_path, :cierre_path, to: :@view 

  def initialize(view) 
    @view = view 
  end 

  def as_json(options = {}) 
    { 
      data: data, 
      recordsTotal: Cierre.count, 
      recordsFiltered: 2
    } 
  end 



private

  def data 
    cierres = [] 
    fetch_products.map do |record| 
      product = [] 
      product << record.id 
      product << record.fechaproceso.to_date.strftime("%d/%m/%Y") 
      product << record.desc
      if record.esoficial
        product << "Si"
      else
        product << "No"
      end
      product << link_to(fa_icon('info-circle lg'), cierre_path(record), class: 'label success round') 
      #product << link_to(fa_icon('edit lg'), edit_cierre_path(record), class: 'label secondary round') 
      #product << link_to(fa_icon('trash-o lg'), cierres_path(record), method: :delete, data: { confirm: 'Are you sure?' }, class: 'label alert round')  #button disabled
      cierres << product 
    end 
    cierres
  end 

  def fetch_products 
    #records = Cierre.where(activo: true).order("#{sort_column} #{sort_direction}")  
    records = CierreCiclo.where("fechaproceso BETWEEN ? and ? and activo = ?", Ciclo.fecha_ini_ciclo(1).to_date.beginning_of_day, Ciclo.fecha_fin_ciclo(1).to_date.beginning_of_day, true).order("#{sort_column} #{sort_direction}") 
    records = records.page(page).per(per_page) 
    if params[:search][:value].present? 
      records = records.where("CIERRE_CICLOS.FECHAPROCESO like :search ", search: "%#{params[:search][:value]}%") 
    end 
    records 
  end 

  def page 
    params[:start].to_i/per_page + 1 
  end 

  def per_page 
    params[:length].to_i > 0 ? params[:length].to_i : 10 
  end 

  def sort_column 
    columns = %w[not_orderable CIERRE_CICLOS.FECHAPROCESO not_orderable not_orderable not_orderable] 
    columns[params[:order][:'0'][:column].to_i] 
  end 

  def sort_direction 
    params[:order][:'0'][:dir] == "desc" ? "desc" : "asc" 
  end 
end