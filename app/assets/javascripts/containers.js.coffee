# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    updateSampleContainerLocations = (x,y) ->
        $("#container_x").attr('value', x)
        $("#container_y").attr('value', y)
    currentSelectedCell = $(".selected")
    $("[data-x]").click ->
        if (currentSelectedCell)
            $(currentSelectedCell).removeClass("selected")
        currentSelectedCell = this
        $(this).addClass("selected")
        updateSampleContainerLocations($(this).data("x"),$(this).data("y"))
    updateContainerWidget = (id) ->
        $.ajax(#{link_to(container_url(id))})
