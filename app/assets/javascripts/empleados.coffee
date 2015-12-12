# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'change', '#departamentos_select', (evt) ->
    $.ajax 'update_povincia',
      type: 'GET'
      dataType: 'script'
      data: {
        Codigodept: $("#departamentos_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

$ ->
  $(document).on 'change', '#provincias_select', (evt) ->
    $.ajax 'update_localidad',
      type: 'GET'
      dataType: 'script'
      data: {
        Codigoprov: $("#provincias_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

$ -> 
  empleados_table = $('#empleados_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/empleados_ajax/datatable_ajax' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "10%" } 
      { width: "35%", className: "row_config" } 
      { width: "null", className: "row_config" } 
      { width: "null", className: "row_config", searchable: false, orderable: false } 
      { width: "null", className: "row_config", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [1,'asc'] ] 