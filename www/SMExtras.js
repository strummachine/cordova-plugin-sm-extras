var exec = require('cordova/exec');

exports.disableIdleTimeout = function (args, success, error) {
  exec(success, error, "SMExtras", 'disableIdleTimeout', []);
};

exports.enableIdleTimeout = function (args, success, error) {
  exec(success, error, "SMExtras", 'enableIdleTimeout', []);
};

exports.share = function(args, success, error) {
  exec(success, error, "SMExtras", "share", [args.text || "", args.title || "", args.url || ""]);
};

/**
 * iOS only methods:
 */

exports.requestAppReview = function(args, success, error) {
  exec(success, error, "SMExtras", "requestAppReview", []);
};

exports.openURL = function(url, success, error) {
  exec(success, error, "SMExtras", "openURL", [url]);
};
