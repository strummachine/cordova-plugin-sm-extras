var exec = require('cordova/exec');

exports.disableIdleTimeout = function (success, error) {
  exec(success, error, "SMExtras", 'disableIdleTimeout', []);
};

exports.enableIdleTimeout = function (success, error) {
  exec(success, error, "SMExtras", 'enableIdleTimeout', []);
};

exports.getLatency = function(success, error) {
  exec(success, error, "SMExtras", "getLatency", []);
};

/**
 * Android-only methods:
 */

exports.share = function(args, success, error) {
  exec(success, error, "SMExtras", "share", [args.text || "", args.title || "", args.url || ""]);
};

/**
 * iOS-only methods:
 */

exports.detectMuteSwitch = function(success, error) {
  exec(success, error, "SMExtras", "detectMuteSwitch", []);
};

exports.openURL = function(url, success, error) {
  exec(success, error, "SMExtras", "openURL", [url]);
};

exports.requestAppReview = function(success, error) {
  exec(success, error, "SMExtras", "requestAppReview", []);
};
