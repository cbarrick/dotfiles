// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.

'use strict';

/* global atom */

var pathlib = require('path');

// Always open markdown files with softwrap
atom.workspaceView.eachEditorView(function (view) {
	var editor = view.getEditor();
	var path = editor.getPath();
	var extension = pathlib.extname(path);
	if (extension === '.md') editor.setSoftWrap(true);
});
