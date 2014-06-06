{$, EditorView} = require 'atom'

# HACK The exports is a function here because we are not sure that the
# `find-and-replace` and `minimap` packages will be available when this
# file is loaded. The binding instance will evaluate the module when
# created because at that point we're sure that both modules have been
# loaded.
module.exports = ->
  findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
  minimap = atom.packages.getLoadedPackage('minimap')

  minimapInstance = require (minimap.path)
  FindResultsView = require (findAndReplace.path + '/lib/find-results-view')

  class MinimapFindResultsView extends FindResultsView
    attach: ->
      minimap = @getMinimap()

      if minimap?
        minimap.miniOverlayer.append(this)
        @adjustResults()

    # As there's a slightly different char width between the minimap font
    # and the editor font we'll retrieve both widths and compute the
    # ratio to properly scale the find results.
    # FIXME I can't wrap my head on why the fixed version of redacted
    # still returns different widths for chars, so during that time
    # I'll use fixed scale.
    adjustResults: ->
      return if @adjusted
      @css '-webkit-transform', "scale3d(#{minimapInstance.getCharWidthRatio()},1,1)"
      @adjusted = true

    getMinimap: ->
      editorView = @getEditor()
      if editorView instanceof EditorView
        return minimapInstance.minimapForEditorView(editorView)

    # HACK We don't want the markers to disappear when they're not
    # visible in the editor visible area so we'll hook on the
    # `markersUpdated` method and replace the corresponding method
    # on the fly.
    markersUpdated: (markers) ->
      minimap = @getMinimap()
      super(markers)
      for k,marker of @markerViews
        marker.intersectsRenderedScreenRows = (range) ->
          return false unless minimap?
          range.intersectsRowRange(minimap.miniEditorView.firstRenderedScreenRow, minimap.miniEditorView.lastRenderedScreenRow)
