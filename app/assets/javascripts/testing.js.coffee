Question = (obj, callback) ->
  @_data = obj
  @_callback = callback
  @_$question = undefined
  @_$c = $('.question_container')
  @_interval = undefined
  @_init()
  

Question::_init = () ->
  tmpl = _.template($('#tmpl_question').html())
  if @_data.kind is 'simple'
    @_data.kind = @_data.kind + '_image' if (@_data.picture.picture.url)

  @_$question = $(tmpl(@_data)).hide().appendTo(@_$c).fadeIn()
  @_$question.data('context', @)

  $timer = @_$question.find('.question_timer')
  time = 100
  old_time = new Date()
  context = @
  @_interval = setInterval (=>
    new_time = new Date()
    time = time - Math.round((new_time - old_time)/1000)
    old_time = new_time
    console.log time
    if time < 0
      clearInterval(context._interval)
      ee.emitEvent('ui_QuestionCtrl', [{value:0, action:'timeout'}, $timer ])
      console.log 'timeout'
    else
      $timer.html(time)
  ), 1000


  if @_data.kind is 'order'
    $q = @_$question
    @_$question.find( "ul" ).sortable
      sort: (event, ui) ->
        $q.addClass 'choosed'
      update: (event, ui) ->
        $n = $q.find('.next')
        s = ''
        $q.find('.question-option').each ->
          s = s + $(@).attr('data-value') if $(@).attr('data-value')
        ee.emitEvent('ui_QuestionCtrl', [{value:s, action:'dragorder'}, $(@) ])

    @_$question.find( "ul" ).disableSelection()
  else 
    ee.addListener('ui_QuestionCtrl', @_questionController)

Question::_questionController = (params, targetElement) ->
  context = $(targetElement).closest('.question').data('context')
  $q = context._$question
  switch params.action
    when 'choose'
      $q.find('.question-option').removeClass 'active'
      context._$question.find('.question-option[data-value="'+params.value+'"]').addClass 'active'
      context._$question.find('.next').attr('data-value', params.value)
      context._$question.addClass 'choosed'
    when 'dragorder'
      $q.find('.question-option').removeClass 'active'
      context._$question.find('.next').attr('data-value', params.value)
      context._$question.addClass 'choosed'
    when 'next'
      if params.value
        clearInterval(context._interval)
        context._$question.fadeOut 500, ->
          $(@).remove()
        context._callback(params.value)
    when 'timeout'
      context._$question.fadeOut 500, ->
        $(@).remove()
      context._callback(0)


Attempt = (player, callback) ->
  @_player = player
  @_questions = undefined
  @_id = undefined
  @_callback = callback
  # @_$c = $('.question_container')
  @_answers = []
  @_init()
  return

Attempt::_init = () ->
  console.log('attempt init')
  @_getQuestions()
  # @_$c.html('')
  return

Attempt::_generateQuestion = (data) ->
  start_t = new Date()
  question = new Question data, (value) =>
    finish_t = new Date()
    time = Math.round(  (finish_t - start_t)/1000 )
    console.log value, time
    time = 100 if time <= 0
    time = 100 if time > 100
    @_answers.push({option:value, time: time}) # time - истраченное время
    if @_answers.length < @_questions.length
      # @_$c.html('')
      @_generateQuestion @_questions[@_answers.length]
    else
      @_sendAnswers()

Attempt::start = () ->
  console.log 'start'
  timer = setInterval (=>
    if @_questions.length > 0
      clearInterval(timer)
      @_generateQuestion(@_questions[0])
      Navigation.openPopup 'test', ->
        console.log 'test was started!!!'     
  ), 1000

Attempt::_sendAnswers = () ->
  $.ajax 
    type: 'POST'
    url: '/api/results/'+@_id
    data: {
      _method: 'put'
      user_id: @_player.id
      token: @_player.token
      answers: JSON.stringify(@_answers)
      bonus: 99
    }
    success: (data) =>
      @_callback(data)
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


class Rating
  @init = () ->
    $.ajax 
      type: 'GET'
      url: '/api/players/'
      success: (data) =>
        tmpl = _.template($('#tmpl_rating').html())
        $c = $('.rating-container ol')
        i = 0
        while i < data.players.length       
          $r = $(tmpl(data.players[i])).appendTo($c)
          console.log data.players[i]
          i++

window.Rating = Rating


class Player  
  @getPlayer = (uid, provider, callback) ->
    console.log uid, provider
    $.ajax 
      type: 'GET'
      url: '/api/players/'+provider+':'+uid
      success: (data) =>
        callback(data)
        return
      error: (xhr, textStatus, error) ->
        console.log xhr.responseJSON.errors
        callback(player)
        return
    


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

  startTest = () ->
    
    stateController('started')
    attempt = new Attempt player, (obj) =>
      $r = $('.result_container')
      $r.find('.pic img').attr('src', player.photo)
      $r.find('.score').html(obj.score)
      $r.find('.player-position').addClass('loading')
      Navigation.closePopup('test')
      Navigation.openPopup('result')
      Player.getPlayer player.id, player.provider, (data) =>
        console.log data
        $r.find('.player-score span').html(data.score)
        $r.find('.player-place span').html(data.place)
        $r.find('.player-position').removeClass('loading')
    t = 5
    $('.screen_test .timer').html(t)
    timer = setInterval (->
      t = t - 1
      $('.screen_test .timer').html(t)
      if t is 1
        attempt.start()
      if t is 0
        clearInterval(timer)
        setTimeout (->
          stateController('auth_done')
          $('.screen_test .timer').html(5)
        ), 1000
    ), 1000


  stateController = (state) ->
    $('.screen_test .state-dependable').hide()
    $('.screen_test .state-dependable[data-state="'+state+'"]').show()

  testingController = (params, targetElement) ->
    switch params.action
      when 'start'
        startTest()
      when 'finish'
        console.log 'finish'
      when 'restart'
        Navigation.changeScreen('test')
        Navigation.closePopup('result')
        startTest()


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