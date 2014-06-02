(function() {
  var CSON, optimist, path, _;

  path = require('path');

  _ = require('underscore-plus');

  optimist = require('optimist');

  CSON = require('./cson');

  module.exports = function(argv) {
    var e, inputFile, object, options, outputFile, outputName, _ref;
    if (argv == null) {
      argv = [];
    }
    options = optimist(argv);
    options.usage('Usage: csonc input_file [output_file]');
    options.alias('r', 'root').boolean('r').describe('r', 'Require that the input file contain an object at the root.')["default"]('r', false);
    argv = options.argv;
    _ref = argv._, inputFile = _ref[0], outputFile = _ref[1];
    if ((inputFile != null ? inputFile.length : void 0) > 0) {
      inputFile = path.resolve(process.cwd(), inputFile);
    } else {
      options.showHelp(console.error);
      process.exit(1);
      return;
    }
    if ((outputFile != null ? outputFile.length : void 0) > 0) {
      outputFile = path.resolve(process.cwd(), outputFile);
    } else {
      outputName = "" + (path.basename(inputFile, path.extname(inputFile))) + ".json";
      outputFile = path.join(path.dirname(inputFile), outputName);
    }
    try {
      object = CSON.readFileSync(inputFile);
      if (argv.r && (!_.isObject(object) || _.isArray(object))) {
        console.error("" + inputFile + " does not contain a root object");
        process.exit(1);
        return;
      }
    } catch (_error) {
      e = _error;
      console.error("Parsing " + inputFile + " failed:", e.message);
      process.exit(1);
    }
    return CSON.writeFileSync(outputFile, object);
  };

}).call(this);
