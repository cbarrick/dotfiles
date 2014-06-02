'use strict';
var jshint = require('jshint').JSHINT,
    transformJSX = require('react-tools').transform,
    _ = require('lodash');

var jsxhint = (function() {
    function modifiedLines(a, b) {
        return _(a).zip(b).reduce(function(modified, lines, i) {
            if (lines[0] !== lines[1]) {
                modified[i] = true;
            }
            return modified;
        }, {});
    }

    var ignored = {
        'W109': true,
        'W064': true,
        'W102': true
    };

    function jsxhint() {
        var args = Array.prototype.slice.call(arguments),
            code = args[0],
            transformedCode,
            errors = [];

        try {
            args[0] = transformedCode = transformJSX(code);
        } catch (e) {
            errors.push({
                line: e.lineNumber,
                character: e.column,
                reason: e.description
            });
        }

        if (_.isEmpty(errors)) {
            jshint.apply(null, args);
            errors = jshint.errors;
        }

        var modified = transformedCode ?
            modifiedLines(code.split('\n'), transformedCode.split('\n')) :
            {};

        jsxhint.errors = _.reject(errors, function(e) {
            return !e || (modified[e.line - 1] && ignored[e.code]);
        });
    }

    jsxhint.errors = [];

    return jsxhint;
})();

module.exports = {
    JSHINT: jshint,
    JSXHINT: jsxhint
};
