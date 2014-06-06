_ = require 'underscore-plus'
{$} = require 'atom'
{Subscriber, Emitter} = require 'emissary'
MinimapFindResultsView = null

PLUGIN_NAME = 'find-and-replace'

module.exports =
class MinimapFindAndReplaceBinding
  Subscriber.includeInto(this)
  Emitter.includeInto(this)

  active: false
  isActive: -> @active

  constructor: (@findAndReplacePackage, @minimapPackage) ->
    @minimap = require(@minimapPackage.path)
    @findAndReplace = require(@findAndReplacePackage.path)

    MinimapFindResultsView = require('./minimap-find-results-view')()

    @minimap.registerPlugin PLUGIN_NAME, this

  activatePlugin: ->
    $(window).on 'find-and-replace:show find-and-replace:toggle find-and-replace:show-replace', @activate
    atom.workspaceView.on 'core:cancel core:close', @deactivate
    @subscribe @minimap, 'activated.minimap', @activate
    @subscribe @minimap, 'deactivated.minimap', @deactivate

    @activate() if @findViewIsVisible() and @minimapIsActive()

  deactivatePlugin: ->
    $(window).off 'find-and-replace:show'
    atom.workspaceView.off 'core:cancel core:close'
    @unsubscribe()
    @deactivate()

  activate: =>
    return @deactivate() unless @findViewIsVisible() and @minimapIsActive()
    return if @active
    @active = true

    @findView = @findAndReplace.findView
    @findModel = @findView.findModel
    @findResultsView = new MinimapFindResultsView(@findModel)

    @subscribe @findModel, 'updated', @markersUpdated

    setImmediate =>
      @findModel.emit('updated', _.clone(@findModel.markers))

  deactivate: =>
    return unless @active
    @active = false

    @findResultsView.detach()
    @unsubscribe @findModel, 'updated'

  destroy: ->
    @deactivate()

    @findAndReplacePackage = null
    @findAndReplace = null
    @minimapPackage = null
    @minimap = null

  findViewIsVisible: ->
    @findAndReplace.findView? and @findAndReplace.findView.parent().length is 1

  minimapIsActive: -> @minimap.active

  markersUpdated: =>
    @findResultsView.detach()
    @findResultsView.attach()
