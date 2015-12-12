class ProveedorsDatatable
  delegate :params, :fa_icon, :link_to, :proveedors_path, :edit_proveedor_path, :proveedor_path, to: :@view 

  def initialize(view)
    @view = view 
  end 

  def as_json(options = {}) 
    { 
      data: data, 
      recordsTotal: Proveedor.count, 
      recordsFiltered: 2
    } 
  end 

private 

  def data 
    proveedors = [] 
    fetch_products.map do |record| 
      product = [] 
      product << record.id 
      product << record.id 
      product << record.fullname
      product << record.Di 
      product << link_to(fa_icon('info-circle lg'), proveedor_path(record), class: 'label success round') 
      product << link_to(fa_icon('edit lg'), edit_proveedor_path(record), class: 'label secondary round') 
      product << link_to(fa_icon('trash-o lg'), proveedors_path(record), method: :delete, data: { confirm: 'Are you sure?' }, class: 'label alert round') 
      proveedors << product 
    end 
    proveedors 
  end 

  def fetch_products 
    records = Proveedor.order("#{sort_column} #{sort_direction}") 
    records = records.page(page).per(per_page) 
    if params[:search][:value].present? 
      records = records.where("PERSONAS.CODIGO like :search or lower(PERSONAS.Apmaterno) like :search or lower(PERSONAS.Appaterno) like :search or lower(PERSONAS.NOMBRES) like :search or lower(PERSONAS.DI) like :search", search: "%#{params[:search][:value]}%") 
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
    columns = %w[not_orderable PERSONAS.CODIGO lower(PERSONAS.NOMBRES) lower(PERSONAS.DI) not_orderable not_orderable] 
    columns[params[:order][:'0'][:column].to_i] 
  end 

  def sort_direction 
    params[:order][:'0'][:dir] == "desc" ? "desc" : "asc" 
  end 
end