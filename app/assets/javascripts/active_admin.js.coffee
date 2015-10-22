#= require active_admin/base

checkPictures = () ->
  if ($('#question_kind').val() is 'simple') || ($('#question_kind').val() is 'order')
    $('.option-picture').slideUp()
  else
    $('.option-picture').slideDown()


$ ->
  checkPictures()
  $('#question_kind').change ->
    checkPictures()