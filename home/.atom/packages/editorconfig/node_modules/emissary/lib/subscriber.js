(function() {
  var Mixin, Signal, Subscriber, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mixin = require('mixto');

  Signal = null;

  module.exports = Subscriber = (function(_super) {
    __extends(Subscriber, _super);

    function Subscriber() {
      _ref = Subscriber.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Subscriber.prototype.subscribeWith = function(eventEmitter, methodName, args) {
      var callback, eventName;
      if (eventEmitter[methodName] == null) {
        throw new Error("Object does not have method '" + methodName + "' with which to subscribe");
      }
      eventEmitter[methodName].apply(eventEmitter, args);
      eventName = args[0];
      callback = args[args.length - 1];
      return this.addSubscription({
        emitter: eventEmitter,
        off: function() {
          var removeListener, _ref1;
          removeListener = (_ref1 = eventEmitter.off) != null ? _ref1 : eventEmitter.removeListener;
          return removeListener.call(eventEmitter, eventName, callback);
        }
      });
    };

    Subscriber.prototype.addSubscription = function(subscription) {
      var emitter;
      if (this.subscriptions == null) {
        this.subscriptions = [];
      }
      this.subscriptions.push(subscription);
      emitter = subscription.emitter;
      if (emitter != null) {
        if (this.subscriptionsByObject == null) {
          this.subscriptionsByObject = new WeakMap;
        }
        if (this.subscriptionsByObject.has(emitter)) {
          this.subscriptionsByObject.get(emitter).push(subscription);
        } else {
          this.subscriptionsByObject.set(emitter, [subscription]);
        }
      }
      return subscription;
    };

    Subscriber.prototype.subscribe = function() {
      var args, eventEmitterOrSubscription;
      eventEmitterOrSubscription = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (args.length === 0) {
        return this.addSubscription(eventEmitterOrSubscription);
      } else {
        if (args.length === 1 && eventEmitterOrSubscription.isSignal) {
          args.unshift('value');
        }
        return this.subscribeWith(eventEmitterOrSubscription, 'on', args);
      }
    };

    Subscriber.prototype.subscribeToCommand = function() {
      var args, eventEmitter;
      eventEmitter = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.subscribeWith(eventEmitter, 'command', args);
    };

    Subscriber.prototype.unsubscribe = function(object) {
      var index, subscription, _i, _j, _len, _len1, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      if (object != null) {
        _ref3 = (_ref1 = (_ref2 = this.subscriptionsByObject) != null ? _ref2.get(object) : void 0) != null ? _ref1 : [];
        for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
          subscription = _ref3[_i];
          subscription.off();
          index = this.subscriptions.indexOf(subscription);
          if (index >= 0) {
            this.subscriptions.splice(index, 1);
          }
        }
        return (_ref4 = this.subscriptionsByObject) != null ? _ref4["delete"](object) : void 0;
      } else {
        _ref6 = (_ref5 = this.subscriptions) != null ? _ref5 : [];
        for (_j = 0, _len1 = _ref6.length; _j < _len1; _j++) {
          subscription = _ref6[_j];
          subscription.off();
        }
        this.subscriptions = null;
        return this.subscriptionsByObject = null;
      }
    };

    return Subscriber;

  })(Mixin);

}).call(this);
