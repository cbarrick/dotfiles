blockTravel = (editor, direction, select) ->
  up        = direction == "up"
  lineCount = editor.getScreenLineCount()
  row       = editor.getCursorScreenPosition().row
  count     = 0

  loop
    count += 1

    if up
      rowIndex = row - count
    else
      rowIndex = row + count

    if rowIndex < 0
      count = row
      break
    else if rowIndex >= lineCount
      count = lineCount - row
      break

    if editor.lineForScreenRow(rowIndex).text.replace(/^\s+|\s+$/g, "") is ""
      break

  if select
    if up
      editor.selectUp(count)
    else
      editor.selectDown(count)
  else
    if up
      editor.moveCursorUp(count)
    else
      editor.moveCursorDown(count)

module.exports =
  activate: ->
    atom.workspaceView.command 'block-travel:move-up', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "up", false)

    atom.workspaceView.command 'block-travel:move-down', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "down", false)

    atom.workspaceView.command 'block-travel:select-up', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "up", true)

    atom.workspaceView.command 'block-travel:select-down', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "down", true)

  blockTravel: blockTravel
