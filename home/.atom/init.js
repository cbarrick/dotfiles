// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.

'use strict';

var path = require('path');

// Always open markdown files with softwrap
atom.workspaceView.eachEditorView(function (view) {
	var path = view.getEditor().getPath();
	var extension = path.extname(path);
	if (extension === '.md') editor.setSoftWrap(true);
});
