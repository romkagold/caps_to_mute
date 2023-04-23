import Foundation
import SimplyCoreAudio
import IOKit.hid

func toggleMicMute() {
    let coreAudio = SimplyCoreAudio()
    guard let defaultInputDevice = coreAudio.defaultInputDevice else {
        print("No default input device found.")
        return
    }
    
    defaultInputDevice.toggleMute()
    let isMuted = defaultInputDevice.isMuted()
    updateCapsLockLED(muted: isMuted)
}

func updateCapsLockLED(muted: Bool) {
    let eventSource = CGEventSource(stateID: .hidSystemState)
    let event = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x39, keyDown: true)
    event?.setFlags(muted ? .maskAlphaShift : [])
    event?.post(tap: .cghidEventTap)
}

func capsLockCallback(context: UnsafeMutableRawPointer?, eventType: IOHIDEventType, event: IOHIDEventRef?) {
    guard let event = event, eventType == .keyboard else { return }
    let keyCode = IOHIDEventGetIntegerValue(event, .keyboardUsage)
    
    // Caps Lock key code is 57 (0x39)
    if keyCode == 0x39 {
        let isDown = IOHIDEventGetIntegerValue(event, .keyboardPress) == 1
        if isDown {
            toggleMicMute()
        }
    }
}

autoreleasepool {
    let hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    IOHIDManagerSetDeviceMatching(hidManager, nil)
    IOHIDManagerRegisterInputValueCallback(hidManager, capsLockCallback, nil)
    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
    
    CFRunLoopRun()
}
