# ---
# AutocompleteFlyout is created by Christian Pelczarski and is freely distributable under the terms of an MIT-style license. 
# This class is for complex use cases (greater than ~150 items in the dataset)
# in where an input field is desired to have autocomplete support
# as well as dropdown box so user can view all of their
# options by selecting the dropdown button.
# Usage: new AutocompleteFlyout('#transaction_chart', dataSrc, { menuName: 'hierarchy' })
# The 2nd argument data source can be any valid datasource according
# to the jqueryui documentation based on categories http://jqueryui.com/demos/autocomplete/#categories
# ---
class @AutocompleteFlyout
  constructor: (selector, @data, @options = {})->
    # menuName is for fgMenu : if multiple flyouts are
    # being used this must be unique for each one
    @options.menuName ||= 'hierarchy'
    # Allow fgMenu onChoosen to be overridden
    @options.onChoosen ||=  (item, menu, caller) =>
                              # Don't set if a category has been clicked
                              unless item.hasClass('category')
                                caller.prev().val item.text()
                                menu.kill()
    @menuId   = "##{@options.menuName}"
    # Don't keep making menus if this class is 
    # called multiple times with the same menuId
    @buildMenu() if $(@menuId).length is 0
    @setupCustomAutocomplete()
    elements = $(selector)
    for el in elements
      el = $(el)
      @setupAutocomplete(el)
      @buildMenuButton(el)

  setupCustomAutocomplete: ->
    $.widget "custom.catcomplete", $.ui.autocomplete,
      _renderMenu: (ul, items) ->
        currentCategory = ""
        $.each items, (index, item) =>
          if item.category != currentCategory
            ul.append "<li class='ui-autocomplete-category'>#{item.category}</li>"
            currentCategory = item.category
          @_renderItem ul, item
  
  setupAutocomplete: (el) ->
    el.catcomplete
      source: @data
      delay: 0
      minLength: 2

  buildMenuButton: (el) ->
    el.after('<span/>')
    .next()
    .button
      icons:
        primary: 'ui-icon-triangle-1-s'
      text: false
    .css('width', '1em')
    .fgMenu
      content: $(@menuId).html()
      flyOut: true
      flyoutWidth: @options.flyoutWidth || null #must be in px e.g. 300px
      shiftFlyoutFromTop: @options.shiftFlyoutFromTop || 0
      maxHeight: @options.maxHeight || 180
      width: @options.width || 180
      onChoosen: @options.onChoosen
      positionOpts:
        posX: 'left'
        posY: 'bottom'
        offsetX: @options.offsetX || 0
        offsetY: @options.offsetY || 0
        directionH: 'right'
        directionV: 'down'
        detectH: true # do horizontal collision detection  
        detectV: false # do vertical collision detection
        linkToFront: false

  buildMenu: ->
    html = ["<div id='#{@options.menuName}' style='display:none;'><ul>"]
    currentCategory = ""
    for chart in @data
      if chart.category != currentCategory
        # If currentCategory is blank we know it is the first run
        # and if so don't concat the ending tags
        html.push '</li></ul>' unless currentCategory is ""
        html.push "<li><a class='category' href='#'>#{chart.category}</a><ul>"
        currentCategory = chart.category
      # DO NOT CLOSE this next line with a </li> as IE will not 
      # render correctly. The other browsers will close it automatically 
      # so there is no harm in leaving it off
      html.push "<li><a href='#' class='label'>#{chart.label}</a>"
    html.push "</ul></div>"
    $('body').append(html.join(''))
