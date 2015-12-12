$ -> 
  cierres_table = $('#cierres_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/cierres/datatable' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "15%", className: "row_config", searchable: true, orderable: true  } 
      { width: "null", className: "row_config", searchable: false, orderable: false }
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [1,'asc'] ] 