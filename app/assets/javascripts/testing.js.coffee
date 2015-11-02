class Noisebox
  currentPlayer = 0
  playersLength = 10
  $box = undefined
  @inited = false

  @bum = () ->
    $p = $box.find('audio').eq(currentPlayer)
    $p.get(0).play()
    currentPlayer++
    currentPlayer = 0 if currentPlayer is playersLength 

  @init = () ->
    $box = $('<div/>').addClass('noisebox')
    $c = $('#bit')
    i = 0
    while i < playersLength
      $p = $c.clone()
      $p.appendTo $box
      $p.get(0).load()
      i++
    @inited = true

window.Noisebox = Noisebox


Timer = (time, $el, callback) ->
  @_interval = undefined
  @_$el = $el
  @_time = time
  @_callback = callback
  @_init()

Timer::_init = () ->
  old_time = new Date()
  @_interval = setInterval (=>
    new_time = new Date()
    @_time = @_time - Math.round((new_time - old_time)/1000)
    old_time = new_time
    if @_time < 0
      @remove()
      @_callback()
    else
      @_$el.html(@_time)
  ), 1000

Timer::remove = () ->
  clearInterval(@_interval)

Question = (obj, callback) ->
  @_data = obj
  @_callback = callback
  @_$question = undefined
  @_$c = $('.question_container')
  @_timer = undefined
  @_init()
  

Question::_init = () ->
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
    
  @_timer = new Timer 100, @_$question.find('.question_timer'), =>
    @_timeout()

Question::_timeout = () ->
  if @_data.kind is 'order'
    s = ''
    @_$question.find('.question-option').each ->
      s = s + $(@).attr('data-value') if $(@).attr('data-value')
  else
    s = 0
  @_answer(s)

Question::_answer = (value) ->
  @_timer.remove() if @_timer
  @_$question.fadeOut 500, ->
    $(@).remove()
  @_callback(value)

BonusQuestion = (step, callback) ->
  @_callback = callback
  @_$question = undefined
  @_$c = $('.question_container')
  @_timer = undefined
  @_step = step
  @_score = 0
  @_$blinker = undefined
  @_$progress = undefined
  @_arr = []
  @_dirty = 0
  @_init()

BonusQuestion.prototype = Object.create(Question.prototype)

BonusQuestion::_init = () ->
  @_data = {kind:'bonus'}
  tmpl = _.template($('#tmpl_bonusquestion').html())
  @_$question = $(tmpl(@_data)).hide().appendTo(@_$c).fadeIn()
  @_$question.find('.play-icon').click (e) =>
    e.stopPropagation()
    @_$question.find('.play-icon').hide()
    @_$question.find('.sound-icon-position').show()
    @_$blinker = @_$question.find('.sound-icon-yellow')
    @_$progress = @_$question.find('.progress')
    @_blink()
    # $bit.get(0).play()
    blinkInterval = setInterval (=>
      if @_dirty > 4
        clearInterval blinkInterval
      else
        setTimeout (=>
          @_blink() 
        ), 100
        Noisebox.bum()
    ), @_step

    $(document).on 'keydown', (e) =>
      e.preventDefault
      @_dirty++
      @_tap(e)

    @_$question.on 'click', (e) =>
      @_dirty++
      @_tap(e)


  # @_timer = new Timer 100, @_$question.find('.question_timer'), =>
  #   @_timeout()

BonusQuestion::_timeout = () ->
  @_finish()

BonusQuestion::_tap = (e) ->
  # чтобы пройти этот вопрос - нужно сделать 21 нажатие
  # это 20 интервалов, за величину каждого полагаются баллы
  # console.log e.which # код клавиши
  if @_arr.length < 21
    d = new Date()
    @_arr.push d
    @_blink()
    @_$progress.css('width', @_arr.length/21*100+'%')
    if @_arr.length > 1
      i = @_arr.length-1
      interval = @_arr[i]-@_arr[i-1]
      delta = Math.abs(@_step-interval)
      percent = delta/@_step
      difficulty = 25 # чем больше число, тем сложнее пройти тест
      # penalty = percent * 10 # сложность: чем больше число, тем сложнее
      bonus = 5 - (difficulty * percent)
      bonus = 0 if bonus < 0
      @_score = @_score + bonus
  if @_arr.length is 21
    @_finish()

BonusQuestion::_finish = () ->
  @_score = Math.round(@_score)
  # @_timer.remove()
  $(document).off 'keydown'
  @_$question.off 'click'
  @_$question.find('.progressbar').hide()
  @_$question.find('.score').html('+ '+@_score+' !')
  setTimeout (=>
    @_answer @_score
  ), 1000

BonusQuestion::_blink = () ->
  @_$blinker.fadeIn(@_step/10).fadeOut(@_step/10)

Attempt = (player, callback) ->
  @_player = player
  @_questions = undefined
  @_id = undefined
  @_callback = callback
  # @_$c = $('.question_container')
  @_answers = []
  @_$loader = undefined
  @_init()
  return

Attempt::_init = () ->
  @_getQuestions()
  @_$loader = $('.popup_test .loader')
  # @_$c.html('')
  return

Attempt::_generateQuestion = (data) ->
  start_t = new Date()
  question = new Question data, (value) =>
    finish_t = new Date()
    time = Math.round(  (finish_t - start_t)/1000 )
    # console.log value, time
    time = 100 if time <= 0
    time = 100 if time > 100
    @_answers.push({option:value, time: time}) # time - истраченное время
    if @_answers.length < @_questions.length
      # @_$c.html('')
      @_generateQuestion @_questions[@_answers.length]
    else
      arr = [250,500,1000] 
      bonusquestion = new BonusQuestion arr[Math.floor(Math.random()*arr.length)], (value) =>
        # console.log 'bonus question result received!'
        @_answers.push({option:value, time: time})
        @_sendAnswers()

Attempt::start = () ->
  timer = setInterval (=>
    if @_questions.length > 0
      clearInterval(timer)
      @_generateQuestion(@_questions[0])
      Navigation.openPopup 'test', -> 
  ), 1000

Attempt::_sendAnswers = () ->
  # console.log '_sendAnswers', @_id, @_answers
  @_$loader.fadeIn()
  $.ajax 
    type: 'POST'
    url: '/api/results/'+@_id
    data: {
      _method: 'put'
      user_id: @_player.id
      token: @_player.token
      answers: JSON.stringify(@_answers)
    }
    success: (data) =>
      @_$loader.fadeOut()
      @_callback(data)
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON
      @_$loader.fadeOut()
      @_callback({score:0})

Attempt::_getQuestions = () ->
  $.ajax 
    type: 'POST'
    url: '/api/results'
    data: {
      user_id: @_player.id
      token: @_player.token
    }
    success: (data) =>
      # console.log 'questions recieved!', data
      @_id = data.id
      @_questions = data.questions

      # debug start
      # @_answers = []
      # i = 0
      # while i < 20
      #   @_answers.push {option:0, time: 1}
      #   i++
      # @_answers.push {option:64, time: 20}
      # @_sendAnswers()
      # debug end
      
    error: (xhr, textStatus, error) ->
      console.log xhr.responseJSON


class Rating
  @init = () ->
    $.ajax 
      type: 'GET'
      url: '/api/players/'
      success: (data) =>
        tmpl = _.template($('#tmpl_rating').html())
        $c1 = $('.rating-container ol.left')
        $c2 = $('.rating-container ol.right')
        i = 0
        l = 5
        l = data.players.length if data.players.length < 5
        while i < l
          $r = $(tmpl(data.players[i])).appendTo($c1)
          i++
        
        l = 10
        l = data.players.length if data.players.length < 10
        while i < l
          $r = $(tmpl(data.players[i])).appendTo($c2)
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
    Noisebox.init()
    
    spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#000000', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
    $loader = $('.screen_test .auth-loader')
    loader = new Spinner(spin_opts).spin $loader[0]

    # # debug start
    # Navigation.openPopup('test')
    # bonusquestion = new BonusQuestion 500, (value) =>
    #   console.log 'bonus question result received!', value
    # # debug end

window.Testing = Testing