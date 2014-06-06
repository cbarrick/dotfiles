MinimapFindAndReplace = require '../lib/minimap-find-and-replace'
{WorkspaceView} = require 'atom'

describe "MinimapFindAndReplace", ->
  beforeEach ->
    runs ->
      atom.workspaceView = new WorkspaceView
      atom.workspaceView.openSync('sample.js')

    runs ->
      atom.workspaceView.attachToDom()
      editorView = atom.workspaceView.getActiveView()
      editorView.setText("This is the file content")

    waitsForPromise ->
      promise = atom.packages.activatePackage('minimap')
      atom.workspaceView.trigger 'minimap:toggle'
      promise

    waitsForPromise ->
      promise = atom.packages.activatePackage('find-and-replace')
      atom.workspaceView.trigger 'find-and-replace:show'
      promise

  describe "when the toggle event is triggered", ->
    beforeEach ->
      waitsForPromise ->
        promise = atom.packages.activatePackage('minimap-find-and-replace')
        atom.workspaceView.trigger 'minimap-find-and-replace:toggle'
        promise

    it 'should exist', ->
      expect()
