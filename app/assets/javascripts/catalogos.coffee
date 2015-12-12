$ ->
  $('#jstree_categories').jstree({
    'core' : {
      'check_callback' : true,
      'data': {
        'url': '/catalogos/listar'
      }
   }
  })

$ ->  
  $('#jstree_categories').on 'select_node.jstree', (e, data) ->
    #alert 'node_id: ' + data.node.id
    $.ajax({
      url: '/catalogos/select_nodo',     
      type: "GET",
      dataType: 'script'
      data: {
        idnodo: data.node.id
      }
    });
    return

$ ->
  $("#create_category").click((e) =>
    jstree = $('#jstree_categories').jstree(true)
    selected = jstree.get_selected() 
    alert "You clicked button ##{selected}"
    $.ajax({
      url: '/catalogos/select_nodo',     
      type: "GET",
      dataType: 'script'
      data: {
        idnodo: selected[0]
      }
    });
  )

  $ ->
  $(document).on 'change', '#nivel_select', (evt) ->
    $.ajax 'update_padre',
      type: 'GET'
      dataType: 'script'
      data: {
        idnivel: $("#nivel_select option:selected").val(),
        idgrupo: $("#grupo_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

  $ ->
  $(document).on 'change', '#grupo_select', (evt) ->
    $.ajax 'update_padre',
      type: 'GET'
      dataType: 'script'
      data: {
        idnivel: $("#nivel_select option:selected").val(),
        idgrupo: $("#grupo_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

  $ ->
  $(document).on 'change', '#padre_select', (evt) ->
    $.ajax 'update_cuentasugerida',
      type: 'GET'
      dataType: 'script'
      data: {
        idpadre: $("#padre_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")




  