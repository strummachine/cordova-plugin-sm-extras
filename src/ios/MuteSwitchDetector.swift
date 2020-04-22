import AudioToolbox

func TestSoundNotificationCompletionProc(_ ssID: SystemSoundID, _ clientData: UnsafeMutableRawPointer?) {
  let detecotr = clientData as? MuteSwitchDetector
  detecotr?.handleComplete()
}

class MuteSwitchDetector {
  private var interval: TimeInterval = 0.0
  private var soundId: SystemSoundID = 0
  private var resultCallback: (Boolean) -> Void

  init() {
    let url = Bundle.main.url(forResource: "mute", withExtension: "caf") as CFURL
    if AudioServicesCreateSystemSoundID(url, UnsafeMutablePointer<SystemSoundID>(mutating: &soundId)) == kAudioServicesNoError {
      AudioServicesAddSystemSoundCompletion(
        soundId,
        CFRunLoopGetMain(),
        CFRunLoopMode.defaultMode,
        TestSoundNotificationCompletionProc,
        (self)
      )
      var yes: UInt32 = 1
      AudioServicesSetProperty(
        kAudioServicesPropertyIsUISound,
        UInt32(MemoryLayout.size(ofValue: soundId)),
        UnsafeRawPointer(&soundId),
        UInt32(MemoryLayout.size(ofValue: yes)),
        UnsafeRawPointer(&yes)
      )
    } else {
      soundId = SystemSoundID(-1)
    }
  }

  func testPlayback(callback: (result: Bool) -> Void) {
    interval = Date.timeIntervalSinceReferenceDate
    self.resultCallback = callback
    AudioServicesPlaySystemSound(soundId)
  }

  func handleComplete() {
    let elapsed = Date.timeIntervalSinceReferenceDate - interval
    let isMute = elapsed < 0.1 // Should have been 0.5 sec, but it seems to return much faster (0.3something)
    if resultCallback {
      resultCallback(isMute)
    }
  }
}