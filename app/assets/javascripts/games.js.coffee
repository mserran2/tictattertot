# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#game_board').on 'click', '.board_box', ->
    surface = $(@).closest('.play_surface')
    box = $(@).addClass("p#{surface.data('player')}")
    $.ajax(
      url: surface.data('gamepath'),
      data: { move:{x:box.data('x'), y:box.data('y')}}
      type: 'PUT',
      dataType: 'json'
    ).fail(->
      box.removeClass("p#{surface.data('player')}")
    ).done((data)->
      console.log(data)
    )

