$ ->
  $(".searchable").select2({
      width:      500,  
      allowClear: true  
    })


 #$ ->
 # $(document).on 'change', '#catalogo_id', (evt) ->
 #   #alert "You clicked button ##{$("#catalogo_id option:selected").val()}"
 #     $.ajax '/rpt_estado_cuenta_dets/aux1_segun_catalogo',
 #     type: 'GET'
 #     dataType: 'script'
 #     data: {
 #       idcatalogo: $("#catalogo_id option:selected").val()
 #     }