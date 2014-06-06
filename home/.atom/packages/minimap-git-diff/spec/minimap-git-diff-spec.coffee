MinimapGitDiff = require '../lib/minimap-git-diff'
{WorkspaceView} = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MinimapGitDiff", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('minimap-git-diff')

  describe "when the minimap-git-diff:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.minimap-git-diff')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'minimap-git-diff:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.minimap-git-diff')).toExist()
        atom.workspaceView.trigger 'minimap-git-diff:toggle'
        expect(atom.workspaceView.find('.minimap-git-diff')).not.toExist()
