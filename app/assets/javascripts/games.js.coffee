# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#game_board').on 'click', '.board_box', ->
    color = "p#{$(@).parent().data('player')}"
    box = $(@).addClass(color)
    $.ajax(
      url: box.closest('.play_surface').data('gamepath'),
      data: { move:{x:box.data('x'), y:box.data('y')}}
      type: 'PUT',
      dataType: 'json'
    ).fail(->
      box.removeClass(color)
    ).done((data)->
      console.log(data)
    )

