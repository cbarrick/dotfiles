CsscombRangeFinder = require './csscomb-range-finder'
Comb = require "csscomb"
fs = require "fs"
CSON = require "season"

module.exports =

  activate: (state) ->
    atom.workspaceView.command 'csscomb:run', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      csscomb(editor)

findConfig = ->
  userConfig = atom.config.get('csscomb')
  if userConfig
    console.log "Found user CSScomb config:", userConfig
    userConfig
  else
    jsonConfig = atom.project.resolve(".csscomb.json")
    csonConfig = atom.project.resolve(".csscomb.cson")
    if fs.existsSync(jsonConfig)
      console.log "Found project CSScomb config:", jsonConfig
      require jsonConfig
    else if fs.existsSync(csonConfig)
      console.log "Found project CSScomb config:", csonConfig
      CSON.readFileSync(csonConfig)
    else
      console.log "Could not find project CSScomb config, using default: 'csscomb'"
      "csscomb"

syntaxes =
  supported: ['css', 'scss', 'less']
  default: 'css'

csscomb = (editor) ->
  ranges = CsscombRangeFinder.rangesFor(editor)
  syntax = editor.getTitle()?.split('.').pop()
  unless syntax in syntaxes.supported
    syntax = syntaxes.default
  config = findConfig()
  ranges.forEach (range) ->
    content = editor.getTextInBufferRange(range)
    comb = new Comb(config)
    result = comb.processString(content, syntax)
    editor.setTextInBufferRange(range, result)
