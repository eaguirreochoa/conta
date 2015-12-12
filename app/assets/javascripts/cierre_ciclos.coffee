$ -> 
  cierre_ciclos_table = $('#cierre_ciclos_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/cierre_ciclos/datatable' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "15%" } 
      { width: "null", className: "row_config" }
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [1,'desc'] ] 