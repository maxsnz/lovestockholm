#= require active_admin/base
#= require lodash.compat.min

checkPictures = () ->
  if ($('#question_kind').val() is 'simple') || ($('#question_kind').val() is 'order')
    $('.option-picture').slideUp()
  else
    $('.option-picture').slideDown()

window.render_question = (question, correct) ->
  question.kind = question.kind + '_image' if (question.picture.picture.url)
  @_$c = $('.question_container')
  question_tmpl = _.template($('#tmpl_question').html())
  console.log question
  $question = $(question_tmpl(question)).appendTo(@_$c)
  $question.addClass('choosed')
  $question.find('.question-option').eq(correct-1).addClass('active')


$ ->
  checkPictures()
  $('#question_kind').change ->
    checkPictures()