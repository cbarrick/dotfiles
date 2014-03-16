{blockTravel} = require '../lib/block-travel'

describe "BlockTravel", ->
  describe "blockTravel(editor, direction)", ->
    [editor, buffer] = []

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('language-javascript')

      runs ->
        editor = atom.project.openSync()
        buffer = editor.getBuffer()
        editor.setText """
          console.log("Hello World");

          console.log("Hello World");

          console.log("Hello 'World'");
        """
        editor.setGrammar(atom.syntax.selectGrammar('test.js'))

    describe "with a down direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([1, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([3, 0])

    describe "with an up direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([3, 0])
        blockTravel(editor, "up", false)
        expect(editor.getCursorBufferPosition()).toEqual([1, 0])

    describe "with folded rows", ->
      beforeEach ->
        editor = atom.project.openSync()
        buffer = editor.getBuffer()
        editor.setText """
          var quicksort = function () {
            var sort = function(items) {
              if (items.length <= 1) return items;
              var pivot = items.shift(), current, left = [], right = [];

              while(items.length > 0) {
                current = items.shift();
                current < pivot ? left.push(current) : right.push(current);
              }

              return sort(left).concat(pivot).concat(sort(right));
            };

            return sort(Array.apply(this, arguments));
          };
        """
        editor.foldBufferRow(5)

      it "properly handles jumping over folded blocks", ->
        editor.setCursorBufferPosition([1, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([4, 0])

        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([9, 0])
        expect(editor.getCursorScreenPosition()).toEqual([7, 0])
