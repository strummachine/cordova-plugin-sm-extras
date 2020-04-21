import StoreKit
import AVFoundation

@objc(SMExtras) class SMExtras : CDVPlugin {

  @objc(disableIdleTimeout:) func disableIdleTimeout(command: CDVInvokedUrlCommand) {
    DispatchQueue.main.async(execute: {
      UIApplication.shared.isIdleTimerDisabled = true

      self.commandDelegate!.send(
        CDVPluginResult(status: CDVCommandStatus_OK),
        callbackId: command.callbackId
      )
    })
  }

  @objc(enableIdleTimeout:) func enableIdleTimeout(command: CDVInvokedUrlCommand) {
    DispatchQueue.main.async(execute: {
      UIApplication.shared.isIdleTimerDisabled = false

      self.commandDelegate!.send(
        CDVPluginResult(status: CDVCommandStatus_OK),
        callbackId: command.callbackId
      )
    })
  }

  @objc(startAudioPlayback:) func startAudioPlayback(command: CDVInvokedUrlCommand) {
    try! AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
    try! AVAudioSession.sharedInstance().setActive(true)

    self.commandDelegate!.send(
      CDVPluginResult(status: CDVCommandStatus_OK),
      callbackId: command.callbackId
    )
  }

  @objc(stopAudioPlayback:) func stopAudioPlayback(command: CDVInvokedUrlCommand) {
    try! AVAudioSession.sharedInstance().setCategory(.ambient)
    try! AVAudioSession.sharedInstance().setActive(false)

    self.commandDelegate!.send(
      CDVPluginResult(status: CDVCommandStatus_OK),
      callbackId: command.callbackId
    )
  }

  @objc(share:) func share(command: CDVInvokedUrlCommand) {
    let text  = command.arguments[0] as? String ?? ""
    //let title = command.arguments[1] as? String ?? ""  // currently unused
    let url   = command.arguments[2] as? String ?? ""

    if let urlForShare = NSURL(string: url) {
      let objectsToShare: [Any] = [text, urlForShare]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      self.viewController.present(activityVC, animated: true, completion: nil)
    }

    self.commandDelegate!.send(
      CDVPluginResult(status: CDVCommandStatus_OK),
      callbackId: command.callbackId
    )
  }

  @objc(requestAppReview:) func requestAppReview(command: CDVInvokedUrlCommand) {
    if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
    } else {
        // Fallback on earlier versions
    }

    self.commandDelegate!.send(
      CDVPluginResult(status: CDVCommandStatus_OK),
      callbackId: command.callbackId
    )
  }

  @objc(openURL:) func openURL(command: CDVInvokedUrlCommand) {
    let url = command.arguments[0] as? String ?? ""
    // e.g. https://itunes.apple.com/app/XXXXXXXXXX?action=write-review

    let writeReviewURL = URL(string: url)!
    UIApplication.shared.open(writeReviewURL, options: [:])

    self.commandDelegate!.send(
      CDVPluginResult(status: CDVCommandStatus_OK),
      callbackId: command.callbackId
    )
  }

}
