# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.TicTT = {}
#Status hash also defined in game.rb
TicTT.status =
  open: 0,
  active: 1,
  draw: 2,
  ended: 3

TicTT.processUpdate = (data)->
  surface = $('.play_surface')
  board = $('#game_board')
  if data.move?
    board.children(".c#{data.move.x}#{data.move.y}").addClass("p#{data.game.binColor} locked")

  switch data.game.status
    when TicTT.status.active
      if 'start' of data
        $('#player_info').text(data.start.displayName)
        if data.game.last_token == surface.data('playtoken')
          #this would mean the player goes second
          surface.addClass("p#{data.game.binColor}")
          surface.data('player', data.game.binColor)
        else
          #this would mean the player goes first
          bincolor = Math.abs(data.game.binColor-1)
          surface.addClass("p#{bincolor}")
          surface.data('player', bincolor)

      if data.game.next_token == surface.data('playtoken')
        surface.addClass("active")
    when TicTT.status.draw
      surface.find('#outcome').addClass('draw').text('What a waste...')
    when TicTT.status.ended
      if data.game.last_token == surface.data('playtoken')
        surface.find('#outcome').addClass('win').text('You rule supremely!')
      else
        surface.find('#outcome').addClass('loss').text('You lost :(')

#setup click handler for boxes
ready = ->
  $('#game_board').on 'click', '.board_box', ->
    surface = $(@).closest('.play_surface')
    return unless surface.hasClass('active')
    surface.removeClass('active')
    box = $(@).addClass("p#{surface.data('player')}")
    $.ajax(
      url: surface.data('gamepath'),
      data: { move:{x:box.data('x'), y:box.data('y')}}
      type: 'PUT',
      dataType: 'json'
    ).fail(->
      box.removeClass("p#{surface.data('player')}")
      surface.addClass('active')
      alert('Could not compute. Please try refreshing.')
    ).done((data)->
      #console.log(data)
    )

  $('#open_games').on 'click', 'a', (e)->
    unless confirm('Are you sure you want to join this game?')
      e.preventDefault()

#ensure compatibility with turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
