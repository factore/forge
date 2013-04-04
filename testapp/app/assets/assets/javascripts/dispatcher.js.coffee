class Dispatcher
  constructor: ->
    @routes = { }

  initialize: ->
    body = $('body')

    controller = body.attr('id')
    action = body.attr('class')

    @dispatch('application', 'initialize')
    @dispatch('application', action)

    @dispatch(controller, 'initialize')
    @dispatch(controller, action)

  route: (amalgam, fn) ->
    [controller, action] = amalgam.split('#')

    @routes[controller] ?= { }
    @routes[controller][action] = fn

  dispatch: (controller, action) ->
    @routes[controller]?[action]?()

APP.dispatcher = new Dispatcher
