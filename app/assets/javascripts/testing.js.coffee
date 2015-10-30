Question = (obj, callback) ->
  @_data = obj
  @_callback = callback
  @_$question = undefined
  @_$c = $('.question_container')
  @_interval = undefined
  @_init()
  

Question::_init = () ->
  context = @
  tmpl = _.template($('#tmpl_question').html())
  if @_data.kind is 'simple'
    @_data.kind = @_data.kind + '_image' if (@_data.picture.picture.url)

  @_$question = $(tmpl(@_data)).hide().appendTo(@_$c).fadeIn()

  if @_data.kind is 'order'
    $q = @_$question
    @_$question.find( "ul" ).sortable
      sort: (event, ui) ->
      update: (event, ui) ->
    @_$question.find( "ul" ).disableSelection()
    @_$question.find('.next').click (e) =>
      s = ''
      $q.find('.question-option').each ->
        s = s + $(@).attr('data-value') if $(@).attr('data-value')
      @_answer(s)
  else
    @_$question.find('.question-option').click (e) =>
      $el = $(e.target).closest('.question-option')
      @_answer($el.attr('data-value'))

    @_$question.find('.next').click (e) =>
      @_answer(0)
    
  $timer = @_$question.find('.question_timer')
  time = 100
  old_time = new Date()
  @_interval = setInterval (=>
    new_time = new Date()
    time = time - Math.round((new_time - old_time)/1000)
    old_time = new_time
    if time < 0
      clearInterval(@_interval)
      if @_data.kind is 'order'
        s = ''
        $q.find('.question-option').each ->
          s = s + $(@).attr('data-value') if $(@).attr('data-value')
      else
        s = 0
      @_answer(s)
    else
      $timer.html(time)
  ), 1000

Question::_answer = (value) ->
  clearInterval(@_interval)
  @_$question.fadeOut 500, ->
    $(@).remove()
  @_callback(value)


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
  timer = setInterval (=>
    if @_questions.length > 0
      clearInterval(timer)
      @_generateQuestion(@_questions[0])
      Navigation.openPopup 'test', -> 
  ), 1000

Attempt::_sendAnswers = () ->
  console.log '_sendAnswers', @_id, @_answers
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
          i++

window.Rating = Rating



class Testing


  startTest = () ->
    $('.screen_test .bottom-position .menu').addClass('unavaliable')
    stateController('started')
    attempt = new Attempt Player.data, (obj) =>
      $r = $('.result_container')
      $r.find('.pic img').attr('src', Player.data.photo)
      $r.find('.score').html(obj.score)
      Navigation.closePopup('test')
      Navigation.openPopup('result')
      Player.updateScore()
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
          $('.screen_test .bottom-position .menu').removeClass('unavaliable')
        ), 1000
    ), 1000


  stateController = (state) ->
    $('.screen_test .state-dependable').hide()
    $('.screen_test .state-dependable[data-state="'+state+'"]').show()

  testingController = (params, targetElement) ->
    switch params.action
      when 'start'
        startTest()
      when 'restart'
        Navigation.changeScreen('test')
        Navigation.closePopup('result')
        startTest()
      when 'authorized'
        stateController('auth_done')


  @init = () ->
    ee.addListener('ui_TestingCtrl', testingController)
    ee.addListener('PlayerCtrl', testingController)
    

    spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#000000', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
    $loader = $('.screen_test .auth-loader')
    loader = new Spinner(spin_opts).spin $loader[0]

window.Testing = Testing