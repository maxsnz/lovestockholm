#= require jquery-2.1.4.min
#= require EventEmitter.min
#= require velocity.min
#= require spin.min
#=  lodash.compat.min
#= require authorize
#= require userinterface
#= require navigation

$ ->
  window.ee = new EventEmitter()
  Navigation.init({currentScreen:'main'})

  spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#ffffff', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
  loader = new Spinner(spin_opts).spin $('.loader')[0]
  $('.loader').hide()

player = {
  id: undefined
  name: undefined
  photo: undefined
  provider: undefined
  token: undefined 
}

test = undefined

prepareAnswerReady = () ->
  $('.start-position').hide()
  $('.answer-position').show()
  $('.answer-button').click ->
    $(@).hide()
    sendAnswer()

window.sendAnswer = () ->
  data = [
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
    {option:1, time:50}
  ]
  $.ajax 
    type: 'POST'
    url: '/api/results/'+test.id
    data: {
      _method: 'put'
      user_id: player.id
      token: player.token
      answers: JSON.stringify(data)
      bonus: 50
    }
    success: (data) =>
      console.log data     
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON

sendStart = () ->
  $.ajax 
    type: 'POST'
    url: '/api/results'
    data: {
      user_id: player.id
      token: player.token
    }
    success: (data) =>
      console.log data
      test = data
      prepareAnswerReady()
      
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON

prepareTestReady = () ->
  $('.auth-position').hide()
  $('.start-position').show()
  $('.start-button').click ->
    $(@).hide()
    sendStart()

sendAuth = (obj) ->
  # Test.user = data
  # console.log obj
  player = obj
  $.ajax 
    type: 'POST'
    # url: '/api/results'
    url: '/api/players'
    data: {
      user_id: player.id
      token: player.token
      name: player.name
      email: player.email
      picture: player.photo
    }
    success: (data) =>
      console.log data, player
      prepareTestReady()
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON.errors

$ ->
  $('.arrow').click ->
    $('.loader').hide()

  $('.auth-button').click ->
    if $(@).attr('data-provider') is 'fb'
      Authorize.authorize.Fb().then (obj)->
        sendAuth(obj)
    if $(@).attr('data-provider') is 'vk'
      Authorize.authorize.Vk().then (obj)->
        sendAuth(obj)
