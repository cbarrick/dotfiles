{Range} = require 'atom'

# Thanks to the sort-lines plugin for this approach
module.exports =
class CsscombRangeFinder
  # Public
  @rangesFor: (editor) ->
    new CsscombRangeFinder(editor).ranges()

  # Public
  constructor: (@editor) ->

  # Public
  ranges: ->
    selectionRanges = @selectionRanges()
    if selectionRanges.length is 0
      [@sortableRangeForEntireBuffer()]
    else
      selectionRanges.map (selectionRange) =>
        @sortableRangeFrom(selectionRange)

  # Internal
  selectionRanges: ->
    @editor.getSelectedBufferRanges().filter (range) ->
      not range.isEmpty()

  # Internal
  sortableRangeForEntireBuffer: ->
    @editor.getBuffer().getRange()

  # Internal
  sortableRangeFrom: (selectionRange) ->
    startRow = selectionRange.start.row
    startCol = 0
    endRow = if selectionRange.end.column == 0
      selectionRange.end.row - 1
    else
      selectionRange.end.row
    endCol = @editor.lineLengthForBufferRow(endRow)

    new Range [startRow, startCol], [endRow, endCol]
