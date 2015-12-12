class AjustesDatatable
  delegate :params, :fa_icon, :link_to, :ajustes_path, :edit_ajuste_path, :ajuste_path, to: :@view 

  def initialize(view) 
    @view = view 
  end 

  def as_json(options = {}) 
    { 
      data: data, 
      recordsTotal: Ajuste.count, 
      recordsFiltered: 2
    } 
  end 



private 

  def data 
    ajustes = [] 
    fetch_products.map do |record| 
      product = [] 
      product << record.id 
      product << record.fechaproceso.to_date.strftime("%d/%m/%Y") 
      product << record.indiceant
      product << record.indiceact 
      product << record.activo
      product << link_to(fa_icon('info-circle lg'), ajuste_path(record), class: 'label success round') 
      product << link_to(fa_icon('edit lg'), edit_ajuste_path(record), class: 'label secondary round') 
      product << link_to(fa_icon('trash-o lg'), ajustes_path(record), method: :delete, data: { confirm: 'Are you sure?' }, class: 'label alert round') 
      ajustes << product 
    end 
    ajustes 
  end 

  def fetch_products 
    records = Ajuste.order("#{sort_column} #{sort_direction}") 
    records = records.page(page).per(per_page) 
    if params[:search][:value].present? 
      records = records.where("AJUSTES.FECHAPROCESO like :search ", search: "%#{params[:search][:value]}%") 
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
    columns = %w[not_orderable AJUSTES.FECHAPROCESO not_orderable not_orderable AJUSTES.ACTIVO not_orderable not_orderable not_orderable] 
    columns[params[:order][:'0'][:column].to_i] 
  end 

  def sort_direction 
    params[:order][:'0'][:dir] == "desc" ? "desc" : "asc" 
  end 
end