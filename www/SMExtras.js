var exec = require('cordova/exec');

exports.disableIdleTimeout = function (args, success, error) {
  exec(success, error, "SMExtras", 'disableIdleTimeout', []);
};

exports.enableIdleTimeout = function (args, success, error) {
  exec(success, error, "SMExtras", 'enableIdleTimeout', []);
};

exports.share = function(args, success,error){
  exec(success, error, "SMExtras", "share", [args.text || "", args.title || "Share"]);
};
