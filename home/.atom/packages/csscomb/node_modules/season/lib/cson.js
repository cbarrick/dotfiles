(function() {
  var CoffeeScript, crypto, csonCache, fs, getCachePath, multiplyString, parseContents, parseContentsSync, parseObject, path, stringifyArray, stringifyBoolean, stringifyIndent, stringifyNull, stringifyNumber, stringifyObject, stringifyString, writeCacheFile, writeCacheFileSync, _;

  crypto = require('crypto');

  path = require('path');

  _ = require('underscore-plus');

  fs = require('fs-plus');

  CoffeeScript = null;

  multiplyString = function(string, n) {
    return new Array(1 + n).join(string);
  };

  stringifyIndent = function(level) {
    if (level == null) {
      level = 0;
    }
    return multiplyString(' ', Math.max(level, 0));
  };

  stringifyString = function(string) {
    string = JSON.stringify(string);
    string = string.slice(1, -1);
    string = string.replace(/\\"/g, '"');
    string = string.replace(/'/g, '\\\'');
    return "'" + string + "'";
  };

  stringifyBoolean = function(boolean) {
    return "" + boolean;
  };

  stringifyNumber = function(number) {
    return "" + number;
  };

  stringifyNull = function() {
    return 'null';
  };

  stringifyArray = function(array, indentLevel) {
    var cson, indent, value, _i, _len;
    if (indentLevel == null) {
      indentLevel = 0;
    }
    if (array.length === 0) {
      return '[]';
    }
    cson = '[\n';
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      value = array[_i];
      indent = stringifyIndent(indentLevel + 2);
      cson += indent;
      if (_.isString(value)) {
        cson += stringifyString(value);
      } else if (_.isBoolean(value)) {
        cson += stringifyBoolean(value);
      } else if (_.isNumber(value)) {
        cson += stringifyNumber(value);
      } else if (_.isNull(value) || value === void 0) {
        cson += stringifyNull(value);
      } else if (_.isArray(value)) {
        cson += stringifyArray(value, indentLevel + 2);
      } else if (_.isObject(value)) {
        cson += "{\n" + (stringifyObject(value, indentLevel + 4)) + "\n" + indent + "}";
      } else {
        throw new Error("Unrecognized type for array value: " + value);
      }
      cson += '\n';
    }
    return "" + cson + (stringifyIndent(indentLevel)) + "]";
  };

  stringifyObject = function(object, indentLevel) {
    var cson, key, prefix, value;
    if (indentLevel == null) {
      indentLevel = 0;
    }
    if (_.isEmpty(object)) {
      return '{}';
    }
    cson = '';
    prefix = '';
    for (key in object) {
      value = object[key];
      if (value === void 0) {
        continue;
      }
      if (_.isFunction(value)) {
        throw new Error("Function specified as value to key: " + key);
      }
      cson += "" + prefix + (stringifyIndent(indentLevel)) + (stringifyString(key)) + ":";
      if (_.isString(value)) {
        cson += " " + (stringifyString(value));
      } else if (_.isBoolean(value)) {
        cson += " " + (stringifyBoolean(value));
      } else if (_.isNumber(value)) {
        cson += " " + (stringifyNumber(value));
      } else if (_.isNull(value)) {
        cson += " " + (stringifyNull(value));
      } else if (_.isArray(value)) {
        cson += " " + (stringifyArray(value, indentLevel));
      } else if (_.isObject(value)) {
        if (_.isEmpty(value)) {
          cson += ' {}';
        } else {
          cson += "\n" + (stringifyObject(value, indentLevel + 2));
        }
      } else {
        throw new Error("Unrecognized value type for key: " + key + " with value: " + value);
      }
      prefix = '\n';
    }
    return cson;
  };

  csonCache = null;

  getCachePath = function(cson) {
    var digest;
    digest = crypto.createHash('sha1').update(cson, 'utf8').digest('hex');
    return path.join(csonCache, "" + digest + ".json");
  };

  writeCacheFileSync = function(cachePath, object) {
    try {
      return fs.writeFileSync(cachePath, JSON.stringify(object));
    } catch (_error) {}
  };

  writeCacheFile = function(cachePath, object) {
    return fs.writeFile(cachePath, JSON.stringify(object));
  };

  parseObject = function(objectPath, contents) {
    if (path.extname(objectPath) === '.cson') {
      if (CoffeeScript == null) {
        CoffeeScript = require('coffee-script');
      }
      return CoffeeScript["eval"](contents, {
        bare: true,
        sandbox: true
      });
    } else {
      return JSON.parse(contents);
    }
  };

  parseContentsSync = function(objectPath, cachePath, contents) {
    var object;
    object = parseObject(objectPath, contents);
    if (cachePath) {
      writeCacheFileSync(cachePath, object);
    }
    return object;
  };

  parseContents = function(objectPath, cachePath, contents, callback) {
    var object, parseError;
    try {
      object = parseObject(objectPath, contents);
      if (cachePath) {
        writeCacheFile(cachePath, object);
      }
      return typeof callback === "function" ? callback(null, object) : void 0;
    } catch (_error) {
      parseError = _error;
      return typeof callback === "function" ? callback(parseError) : void 0;
    }
  };

  module.exports = {
    setCacheDir: function(cacheDirectory) {
      return csonCache = cacheDirectory;
    },
    isObjectPath: function(objectPath) {
      var extension;
      if (!objectPath) {
        return false;
      }
      extension = path.extname(objectPath);
      return extension === '.cson' || extension === '.json';
    },
    resolve: function(objectPath) {
      var csonPath, jsonPath;
      if (objectPath == null) {
        objectPath = '';
      }
      if (!objectPath) {
        return null;
      }
      if (this.isObjectPath(objectPath) && fs.isFileSync(objectPath)) {
        return objectPath;
      }
      jsonPath = "" + objectPath + ".json";
      if (fs.isFileSync(jsonPath)) {
        return jsonPath;
      }
      csonPath = "" + objectPath + ".cson";
      if (fs.isFileSync(csonPath)) {
        return csonPath;
      }
      return null;
    },
    readFileSync: function(objectPath) {
      var cachePath, contents;
      contents = fs.readFileSync(objectPath, 'utf8');
      if (csonCache && path.extname(objectPath) === '.cson') {
        cachePath = getCachePath(contents);
        if (fs.isFileSync(cachePath)) {
          try {
            return JSON.parse(fs.readFileSync(cachePath, 'utf8'));
          } catch (_error) {}
        }
      }
      return parseContentsSync(objectPath, cachePath, contents);
    },
    readFile: function(objectPath, callback) {
      return fs.readFile(objectPath, 'utf8', (function(_this) {
        return function(error, contents) {
          var cachePath;
          if (error != null) {
            return typeof callback === "function" ? callback(error) : void 0;
          } else {
            if (csonCache && path.extname(objectPath) === '.cson') {
              cachePath = getCachePath(contents);
              return fs.stat(cachePath, function(error, stat) {
                if (stat != null ? stat.isFile() : void 0) {
                  return fs.readFile(cachePath, 'utf8', function(error, cached) {
                    var parsed;
                    try {
                      parsed = JSON.parse(cached);
                    } catch (_error) {
                      error = _error;
                      try {
                        parseContents(objectPath, cachePath, contents, callback);
                      } catch (_error) {}
                      return;
                    }
                    return typeof callback === "function" ? callback(null, parsed) : void 0;
                  });
                } else {
                  return parseContents(objectPath, cachePath, contents, callback);
                }
              });
            } else {
              return parseContents(objectPath, null, contents, callback);
            }
          }
        };
      })(this));
    },
    writeFile: function(objectPath, object, callback) {
      var contents, error;
      try {
        contents = this.stringifyPath(objectPath, object);
      } catch (_error) {
        error = _error;
        callback(error);
        return;
      }
      return fs.writeFile(objectPath, "" + contents + "\n", callback);
    },
    writeFileSync: function(objectPath, object) {
      return fs.writeFileSync(objectPath, "" + (this.stringifyPath(objectPath, object)) + "\n");
    },
    stringifyPath: function(objectPath, object) {
      if (path.extname(objectPath) === '.cson') {
        return this.stringify(object);
      } else {
        return JSON.stringify(object, void 0, 2);
      }
    },
    stringify: function(object) {
      if (object === void 0) {
        throw new Error("Cannot stringify undefined object");
      }
      if (_.isFunction(object)) {
        throw new Error("Cannot stringify function: " + object);
      }
      if (_.isString(object)) {
        return stringifyString(object);
      }
      if (_.isBoolean(object)) {
        return stringifyBoolean(object);
      }
      if (_.isNumber(object)) {
        return stringifyNumber(object);
      }
      if (_.isNull(object)) {
        return stringifyNull(object);
      }
      if (_.isArray(object)) {
        return stringifyArray(object);
      }
      if (_.isObject(object)) {
        return stringifyObject(object);
      }
      throw new Error("Unrecognized type to stringify: " + object);
    }
  };

}).call(this);
