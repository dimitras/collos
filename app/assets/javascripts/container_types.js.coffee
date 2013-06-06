# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#container_type_type_term').autocomplete
    source: $('#container_type_type_term').data('autocomplete-source')
