import AVFoundation

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
    let title = command.arguments[1] as? String ?? ""
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

}
