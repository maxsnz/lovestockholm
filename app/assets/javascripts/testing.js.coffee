Question = (obj, attempt) ->
  @_data = obj
  @_attempt = attempt
  @_$question = undefined
  @_$c = $('.question_container')
  @_init()

Question::_init = () ->
  tmpl = _.template($('#tmpl_question').html())
  if @_data.kind is 'simple'
    @_data.kind = @_data.kind + '_image' if (@_data.picture.picture.url)

  @_$question = $(tmpl(@_data)).appendTo(@_$c)
  @_$question.data('context', @)

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
        context._attempt.answeredQuestion(params.value)


Question::_choose = (value) ->

Question::_answer = (value) ->
  

Attempt = (player) ->
  @_player = player
  @_questions = undefined
  @_id = undefined
  @_$c = $('.question_container')
  @_answers = []
  @_init()
  
  return


Attempt::_init = () ->
  console.log('attempt init')
  @_getQuestions()
  @_$c.html('')
  return

Attempt::answeredQuestion = (value) ->
  console.log value
  @_answers.push({option:value, time: 50})
  if @_answers.length < @_questions.length
    @_$c.html('')
    @_generateQuestion @_questions[@_answers.length]
  else
    @_sendAnswers()

Attempt::_generateQuestion = (data) ->
  question = new Question(data, @)


Attempt::start = () ->
  console.log 'start'
  timer = setInterval (=>
    if @_questions.length > 0
      clearInterval(timer)
      @_generateQuestion(@_questions[0])
      Navigation.openPopup 'test', ->
        console.log 'test was started!!!'     
  ), 1000
  

Attempt::_stateAsString = ->

Attempt::_sendAnswers = () ->
  $.ajax 
    type: 'POST'
    url: '/api/results/'+@_id
    data: {
      _method: 'put'
      user_id: @_player.id
      token: @_player.token
      answers: JSON.stringify(@_answers)
      bonus: 50
    }
    success: (data) =>
      @_showResult(data)
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

Attempt::_showResult = (obj) ->
  obj.player = @_player
  console.log obj
  tmpl = _.template($('#tmpl_result').html())
  @_$c.html('')
  $result = $(tmpl(obj)).appendTo(@_$c)


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