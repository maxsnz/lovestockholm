#=  react
#=  react_ujs
#=  components

#= require jquery-2.1.4.min
#= require jquery-ui.min
#= require EventEmitter.min
#= require lodash.compat.min
#= require velocity.min
#= require spin.min
#= require authorize
#= require userinterface
#= require navigation
#= require testing

$ ->
  window.ee = new EventEmitter()
  Navigation.init({currentScreen:'main'})
  # Navigation.openPopup('result')
  Testing.init()
  Rating.init()
  

  spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#ffffff', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
  $loader = $('body>.loader, .result-player-loader')
  loader = new Spinner(spin_opts).spin $loader[0]
  $('body>.loader').hide() # TODO
  return


