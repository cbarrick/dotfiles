(function() {
  var Channel, Mixin, Prolix, prolixes,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mixin = require('mixto');

  prolixes = {};

  Channel = (function() {
    function Channel(name, active) {
      this.name = name;
      this.active = active;
    }

    Channel.prototype.isActive = function() {
      return this.active;
    };

    Channel.prototype.activate = function() {
      return this.active = true;
    };

    Channel.prototype.deactivate = function() {
      return this.active = false;
    };

    return Channel;

  })();

  Prolix = function(channelName, active) {
    var ConcreteProlix, _ref;
    if (active == null) {
      active = false;
    }
    if (prolixes[channelName] != null) {
      return prolixes[channelName];
    }
    return prolixes[channelName] = ConcreteProlix = (function(_super) {
      var channel;

      __extends(ConcreteProlix, _super);

      function ConcreteProlix() {
        _ref = ConcreteProlix.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      channel = new Channel(channelName, active);

      ConcreteProlix.prototype.getChannel = function() {
        return channel;
      };

      ConcreteProlix.prototype.log = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (this.canLog()) {
          return console.log.apply(console, args);
        }
      };

      ConcreteProlix.prototype.startBench = function() {
        if (this.canLog()) {
          return this.benchmarkTimes = [new Date];
        }
      };

      ConcreteProlix.prototype.markIntermediateTime = function(label) {
        var time;
        if (this.canLog()) {
          time = this.logIntermediateTime(label);
          return this.benchmarkTimes.push(time);
        }
      };

      ConcreteProlix.prototype.endBench = function(label) {
        if (this.canLog()) {
          this.markIntermediateTime(label);
          this.benchmarkTimes = null;
          return this.log('\n');
        }
      };

      ConcreteProlix.prototype.logIntermediateTime = function(label) {
        var firstTime, lastIndex, lastTime, results, time;
        if (this.canLog()) {
          time = new Date;
          firstTime = this.benchmarkTimes[0];
          lastIndex = this.benchmarkTimes.length - 1;
          results = "" + (time - firstTime) + "ms";
          if (lastIndex !== 0) {
            lastTime = this.benchmarkTimes[lastIndex];
            results += " (" + (time - lastTime) + "ms)";
          }
          this.log("" + label + ": " + results);
          return time;
        }
      };

      ConcreteProlix.prototype.canLog = function() {
        return this.getChannel().isActive() && atom.inDevMode();
      };

      return ConcreteProlix;

    })(Mixin);
  };

  module.exports = Prolix;

}).call(this);
