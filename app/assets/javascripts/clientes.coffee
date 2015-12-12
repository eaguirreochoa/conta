$ -> 
  clientes_table = $('#clientes_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/clientes/datatable' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "15%" } 
      { width: "35%", className: "row_config" } 
      { width: "null", className: "row_config" } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [1,'asc'] ] 