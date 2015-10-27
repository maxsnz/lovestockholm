Attempt = (player) ->
  @_player = player
  @_questions = undefined
  @_id = undefined
  @_$c = $('.question_container')
  @_init()
  
  return


Attempt::_init = () ->
  console.log('attempt init')
  @_getQuestions()
  @_$c.html('')
  return

Attempt::_renderQuestion = (question) ->
  question_tmpl = _.template($('#tmpl_question').html())
  console.log question
  $question = $(question_tmpl(question)).appendTo(@_$c)


Attempt::start = () ->
  console.log 'start'
  timer = setInterval (=>
    if @_questions.length > 0
      clearInterval(timer)
      @_renderQuestion(@_questions[0])
      Navigation.openPopup 'test', ->
        console.log 'test was started!!!'     
  ), 1000
  

Attempt::_stateAsString = ->

Attempt::_sendAnswers = () ->
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
      user_id: @_player.id
      token: @_player.token
      answers: JSON.stringify(data)
      bonus: 50
    }
    success: (data) =>
      console.log data     
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON

Attempt::_getQuestions = () ->
  $.ajax 
    type: 'POST'
    url: '/api/results'
    data: {
      user_id: @_player.id
      token: @_player.token
    }
    success: (data) =>
      console.log 'questions recieved!', data
      @_id = data.id
      @_questions = data.questions
      
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON


class Testing

  player = {
    id: undefined
    name: undefined
    photo: undefined
    provider: undefined
    token: undefined 
  }

  sendAuth = (obj) ->
    stateController('auth_loading')
    player = obj
    $.ajax 
      type: 'POST'
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
        stateController('auth_done')
      error: (xhr, textStatus, error) ->
        stateController('auth_error')
        console.log xhr.responseJSON.errors

  stateController = (state) ->
    console.log state
    $('.screen_test .state-dependable').hide()
    $('.screen_test .state-dependable[data-state="'+state+'"]').show()

  testingController = (params, targetElement) ->
    switch params.action
      when 'start'
        stateController('started')
        attempt = new Attempt(player)
        t = 5
        $('.screen_test .timer').html(t)
        timer = setInterval (->
          
          t = t - 1
          $('.screen_test .timer').html(t)
          if t is 1
            attempt.start()
          if t is 0
            clearInterval(timer)

            
        ), 1000
      when 'finish'
        console.log 'finish'

  authController = (params, targetElement) ->
    switch params.action
      when 'auth'
        # stateController('auth_loading')
        switch params.provider
          when 'fb'
            Authorize.authorize.Fb().then (obj)->
              sendAuth(obj)
          when 'vk'
            Authorize.authorize.Vk().then (obj)->
              sendAuth(obj)
      when 'back'
        console.log('back')


  @init = () ->
    ee.addListener('ui_TestingCtrl', testingController)
    ee.addListener('ui_AuthCtrl', authController)

    spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#000000', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
    $loader = $('.screen_test .auth-loader')
    loader = new Spinner(spin_opts).spin $loader[0]

window.Testing = Testing