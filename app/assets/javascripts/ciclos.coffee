$ -> 
  ciclos_table = $('#ciclos_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/ciclos/datatable' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "15%" } 
      { width: "15%", className: "row_config", searchable: false, orderable: false } 
      { width: "15%", className: "row_config", searchable: false, orderable: false } 
      { width: "null", className: "row_config" }
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [1,'desc'] ] 