{$} = require 'atom'
{Subscriber, Emitter} = require 'emissary'

module.exports =
class MinimapGitDiffBinding
  Subscriber.includeInto(this)
  Emitter.includeInto(this)

  active: false

  constructor: (@editorView, @gitDiffPackage, @minimapView) ->
    {@editor} = @editorView
    @gitDiff = require(@gitDiffPackage.path)

  activate: ->
    @subscribe @editorView, 'editor:path-changed', @subscribeToBuffer
    @subscribe @editorView, 'editor:contents-modified', @renderDiffs
    @subscribe atom.project.getRepo(), 'statuses-changed', =>
      @scheduleUpdate()
    @subscribe atom.project.getRepo(), 'status-changed', (path) =>
      @scheduleUpdate()

    @subscribeToBuffer()

    @updateDiffs()

  deactivate: ->
    @removeDiffs()
    @unsubscribe()

  scheduleUpdate: ->
    setImmediate(@updateDiffs)

  updateDiffs: =>
    return unless @buffer?

    @renderDiffs()

  renderDiffs: =>
    @removeDiffs()

    diffs = @getDiffs()
    displayBuffer = @editor.displayBuffer
    return unless diffs?

    for {newLines, oldLines, newStart, oldStart} in diffs
      if oldLines is 0 and newLines > 0
        for row in [newStart...newStart + newLines]
          start = displayBuffer.screenRowForBufferRow(row)
          end = displayBuffer.lastScreenRowForBufferRow(row)
          @decorateLines(start, end, 'added')

      else if newLines is 0 and oldLines > 0
        start = displayBuffer.screenRowForBufferRow(newStart)
        end = displayBuffer.lastScreenRowForBufferRow(newStart)

        # start from fist line
        if start is 0 and start is end
          start = end = 1

        @decorateLines(start, end, 'removed')

      else
        for row in [newStart...newStart + newLines]
          start = displayBuffer.screenRowForBufferRow(row)
          end = displayBuffer.lastScreenRowForBufferRow(row)
          @decorateLines(start, end, 'modified')

  decorateLines: (start, end, status) ->

    for row in [start..end]
      @minimapView.addLineClass(row, "git-line-#{status}")

  removeDiffs: ->
    @minimapView?.removeAllLineClasses('git-line-added', 'git-line-removed', 'git-line-modified')

  destroy: ->
    @deactivate()

  getPath: -> @buffer.getPath()

  getRepo: -> atom.project.getRepo()

  getDiffs: ->
    @getRepo()?.getLineDiffs(@getPath(), @editorView.getText())

  unsubscribeFromBuffer: ->
    if @buffer?
      @removeDiffs()
      @buffer = null

  subscribeToBuffer: =>
    @unsubscribeFromBuffer()

    if @buffer = @editor.getBuffer()
      @buffer.on 'contents-modified', @updateDiffs
