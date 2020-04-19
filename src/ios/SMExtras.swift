import StoreKit

@objc(SMExtras) class SMExtras : CDVPlugin {

  @objc(disableIdleTimeout:) func disableIdleTimeout(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_OK
    )

    DispatchQueue.main.async(execute: {
      UIApplication.shared.isIdleTimerDisabled = true

      self.commandDelegate!.send(
        pluginResult,
        callbackId: command.callbackId
      )
    })
  }

  @objc(enableIdleTimeout:) func enableIdleTimeout(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_OK
    )

    DispatchQueue.main.async(execute: {
      UIApplication.shared.isIdleTimerDisabled = false

      self.commandDelegate!.send(
        pluginResult,
        callbackId: command.callbackId
      )
    })
  }

  @objc(share:) func share(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_OK
    )

    let text  = command.arguments[0] as? String ?? ""
    let title = command.arguments[1] as? String ?? ""  // currently unused
    let url   = command.arguments[2] as? String ?? ""

    if let urlForShare = NSURL(string: url) {
      let objectsToShare = [text, urlForShare]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = sender
      self.presentViewController(activityVC, animated: true, completion: nil)
    }

    self.commandDelegate!.send(
      pluginResult,
      callbackId: command.callbackId
    )
  }

  @objc(requestAppReview:) func requestAppReview(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_OK
    )

    SKStoreReviewController.requestReview()

    self.commandDelegate!.send(
      pluginResult,
      callbackId: command.callbackId
    )
  }

  @objc(openURL:) func openURL(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_OK
    )

    let url = command.arguments[0] as? String ?? ""
    // e.g. https://itunes.apple.com/app/XXXXXXXXXX?action=write-review

    let writeReviewURL = URL(string: url)
    UIApplication.shared.open(writeReviewURL, options: [:])

    self.commandDelegate!.send(
      pluginResult,
      callbackId: command.callbackId
    )
  }

}
