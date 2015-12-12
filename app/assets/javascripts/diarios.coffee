$ -> 
  empleados_table = $('#diarios_table').DataTable 
    processing: true 
    serverSide: true 
    ajax: 
      url: '/diarios/listar' 
    columns: [ 
      { width: "0%", className: "dont_show", searchable: false, orderable: false } 
      { width: "5%", className: "row_config", searchable: false, orderable: false } 
      { width: "5%", className: "row_config", searchable: false, orderable: false } 
      { width: "80%", className: "row_config", searchable: true, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
      { width: "5%", className: "center", searchable: false, orderable: false } 
    ] 
    order: [ [0,'desc'] ] 


$ ->
  $(document).on 'change', '.catalogo_select', (evt) ->
    selected = $(this).attr('id')
    n = selected.split('_')
    id = "diario_diariodets_attributes_" + n[3] + "_catalogo_id"
    #alert "catalogo_select ##{id}"
    idselect = "#" + id + " option:selected" 
    $.ajax '/diarios/update_segun_catalogo',
      type: 'GET'
      dataType: 'script'
      data: {
        idcuenta: $("#{idselect}").val(),
        item:  n[3]
      }
$ ->
 $('#detail-association-insertion-point').on 'cocoon:after-insert', (e, added_diariodet) ->
  #alert "You clicked button ##{added_diariodet}"
  #added_diariodet.css("background","red")
  #added_diariodet.find("#item").hide()
  #added_diariodet[0].getElementsByTagName('input')[0].value = 1
  a = 0
  $('.item_text').each ->
    if Number($(this).val()) > a
      a = Number($(this).val())
    #alert "may ##{a}"
    return
  a = a + 1
  added_diariodet.find('.item_text').val(a) 
  added_diariodet.find('.debeori_number').val(0) 
  added_diariodet.find('.haberori_number').val(0) 

$ ->
  $(document).on 'change', '.catalogo_codigo_change', (evt) ->
    selected = $(this).attr('id')
    n = selected.split('_')
    id = "diario_diariodets_attributes_" + n[3] + "_catalogo_codigo"
    idselect = "#" + id + "" 
    #alert $("#{idselect}").val()
    #alert $("#{id}").val()
    ##idselect = "#" + id + " option:selected" 
    $.ajax '/diarios/buscar_cuenta',
      type: 'GET'
      dataType: 'script'
      data: {
        codigo: $("#{idselect}").val(),
        item:  n[3]
      }

$ ->
  $(document).on 'change', '#tipocomprobantes_select', (evt) ->
    $.ajax '/diarios/update_nrocbte',
      type: 'GET'
      dataType: 'script'
      data: {
        idtipocbte: $("#tipocomprobantes_select option:selected").val(),
        idempresa: $("#diario_empresa_id").val()
        fecha: $("#diario_fechacbte").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")


$ ->
  $(document).on 'change', '.debeori_number', (evt) ->
    sumdebe = 0
    $('.debeori_number').each ->
      sumdebe = sumdebe + Number($(this).val())
      return
    $('#total_debe').html(sumdebe)

$ ->
  $(document).on 'change', '.haberori_number', (evt) ->
    sumhaber = 0
    $('.haberori_number').each ->
      sumhaber = sumhaber + Number($(this).val())
      return
    $('#total_haber').html(sumhaber)

