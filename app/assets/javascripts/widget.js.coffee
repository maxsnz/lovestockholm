#= require jquery-2.1.4.min
#= require authorize

sendAuth = (data) =>
  # Test.user = data

  $.ajax 
    type: 'POST'
    # url: '/api/results'
    url: '/api/players'
    data: {
      user_id: data.id
      token: data.token
      name: data.name
      email: data.email
      picture: data.photo
      provider: data.provider
    }
    success: (data) =>
      console.log data
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
