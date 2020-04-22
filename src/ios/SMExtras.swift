import StoreKit
import AVFoundation

@objc(SMExtras) class SMExtras : CDVPlugin {

  private lazy var muteSwitchDetector = MuteSwitchDetector()

  @objc(getLatency:) func getLatency(command: CDVInvokedUrlCommand) {
    DispatchQueue.main.async(execute: {
      let latency = AVAudioSession.sharedInstance().outputLatency + AVAudioSession.sharedInstance().ioBufferDuration
      self.commandDelegate!.send(
        CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAs: latency
        ),
        callbackId: command.callbackId
      )
    })
  }

  @objc(detectMuteSwitch:) func detectMuteSwitch(command: CDVInvokedUrlCommand) {
    DispatchQueue.main.async(execute: {
      muteSwitchDetector.testPlayback() { silent in
        self.commandDelegate!.send(
          CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: silent
          ),
          callbackId: command.callbackId
        )
      }
    })
  }

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
