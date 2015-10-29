#= require active_admin/base
#= require jquery-ui.min
#= require lodash.compat.min

checkPictures = () ->
  if ($('#question_kind').val() is 'simple') || ($('#question_kind').val() is 'order')
    $('.option-picture').slideUp()
  else
    $('.option-picture').slideDown()

window.render_question = (question, correct) ->
  if question.kind is 'simple'
    question.kind = question.kind + '_image' if (question.picture.picture.url)
  @_$c = $('.question_container')
  question_tmpl = _.template($('#tmpl_question').html())
  console.log question
  $question = $(question_tmpl(question)).appendTo(@_$c)
  $question.addClass('choosed')
  $question.find('.question-option').eq(correct-1).addClass('active')
  if question.kind is 'order'
    $question.find( "ul" ).sortable()
    $question.find( "ul" ).disableSelection()
    i = 3
    $question.find(".question-option").each ->
      $(@).find('.question-option-n').html(correct[i])
      i--


$ ->
  checkPictures()
  $('#question_kind').change ->
    checkPictures()