import Foundation
import CoreGraphics
import AppKit

// Global variables (for access in event callbacks)
private var isMouseButton3Pressed = false
private var isMouseButton2Pressed = false
private var initialMousePosition: NSPoint = NSPoint.zero
private let minimumDragDistance: CGFloat = 50.0
private var mouseButton2StartPosition: NSPoint = NSPoint.zero
private var mouseButton3StartPosition: NSPoint = NSPoint.zero
private var mouseButton3HasDragged = false

// Global function to be used as C function pointer
func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    switch type {
    case .otherMouseDown:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ Mouse button pressed - Button number: \(buttonNumber)")
        
        // Check if mouse button 2 (right click) is pressed
        if buttonNumber == 2 {
            isMouseButton2Pressed = true
            mouseButton2StartPosition = NSEvent.mouseLocation
        }
        // Check if mouse button 3 (wheel click) is pressed
        else if buttonNumber == 3 {
            isMouseButton3Pressed = true
            mouseButton3StartPosition = NSEvent.mouseLocation
            mouseButton3HasDragged = false
        }
        // Check if mouse button 4 is pressed
        else if buttonNumber == 4 {
            DesktopSwitcher.toggleFullscreen()
        }
        
    case .otherMouseUp:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ Mouse button released - Button number: \(buttonNumber)")
        
        if buttonNumber == 2 {
            isMouseButton2Pressed = false
            
            // Calculate distance when mouse button 2 is released and execute browser navigation
            let endPosition = NSEvent.mouseLocation
            let deltaX = endPosition.x - mouseButton2StartPosition.x
            
            // Check minimum drag distance
            if abs(deltaX) >= minimumDragDistance {
                if deltaX > 0 {
                    // Right drag - Go back
                    print("⬅️ Mouse button 2 Right drag detected - Browser go back")
                    DesktopSwitcher.browserGoBack()
                } else {
                    // Left drag - Go forward
                    print("➡️ Mouse button 2 Left drag detected - Browser go forward")
                    DesktopSwitcher.browserGoForward()
                }
            }
        }
        else if buttonNumber == 3 {
            isMouseButton3Pressed = false
            
            // If no drag occurred when mouse button 3 is released, execute Mission Control
            if !mouseButton3HasDragged {
                let endPosition = NSEvent.mouseLocation
                let deltaX = endPosition.x - mouseButton3StartPosition.x
                
                // If drag distance is less than minimum, treat as simple click
                if abs(deltaX) < minimumDragDistance {
                    print("✅ Mouse button 3 simple click - Execute Mission Control")
                    DesktopSwitcher.showMissionControl()
                } else {
                    if deltaX > 0 {
                        print("⬅️ Mouse button 3 Right drag detected - Desktop go left")
                        DesktopSwitcher.switchToPrevious()
                    } else{
                        print("➡️ Mouse button 3 Left drag detected - Desktop go right")
                        DesktopSwitcher.switchToNext()
                    }
                    
                }
            }
        
        }
      
    default:
        break
    }
    
    return Unmanaged.passUnretained(event)
}

class DesktopSwitcher {
    
    // Variables for mouse event monitoring
    private static var eventTap: CFMachPort?

    // ✅ Switch to 'next' desktop
    static func switchToNext() {
        let script = """
        tell application "System Events" to key code 124 using {control down}
        """
        runAppleScript(script: script)
    }

    // ✅ Switch to 'previous' desktop (modified to use AppleScript)
    static func switchToPrevious() {
        let script = """
        tell application "System Events" to key code 123 using {control down}
        """
        runAppleScript(script: script)
    }
    
    // ✅ Changed to class method by adding 'static'
    private static func runAppleScript(script: String) {
        // Create NSAppleScript object
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            // Execute the script
            appleScript.executeAndReturnError(&error)
            
            if let err = error {
                print("AppleScript error: \(err)")
            } else {
                print("AppleScript executed successfully: \(script)")
            }
        }
    }
    
    // MARK: - Browser Navigation Features
    
    /// Browser go back
    static func browserGoBack() {
        let script = """
        tell application "System Events" to key code 33 using {command down}
        """
        runAppleScript(script: script)
    }
    
    /// Browser go forward
    static func browserGoForward() {
        let script = """
        tell application "System Events" to key code 30 using {command down}
        """
        runAppleScript(script: script)
    }
    
    // MARK: - Fullscreen and Mission Control Features
    
    /// Toggle fullscreen
    static func toggleFullscreen() {
        let script = """
        tell application "System Events" to key code 3 using {command down, control down}
        """
        runAppleScript(script: script)
    }
    
    /// Show Mission Control
    static func showMissionControl() {
        let script = """
        tell application "System Events" to key code 160
        """
        runAppleScript(script: script)
    }



    // MARK: - Desktop Switching with Mouse Drag
    
    /// Start mouse event monitoring
    static func startMouseEventMonitoring() {
        // Don't start if already monitoring
        guard eventTap == nil else { return }
        
        // Check accessibility permissions
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        guard isTrusted else {
            print("Accessibility permission required.")
            return
        }
        
        // Create event tap (detect mouse events)
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(1 << CGEventType.otherMouseDown.rawValue) | CGEventMask(1 << CGEventType.otherMouseUp.rawValue) | CGEventMask(1 << CGEventType.otherMouseDragged.rawValue),
            callback: { (proxy, type, event, refcon) in
                return eventCallback(proxy: proxy, type: type, event: event, refcon: refcon)
            },
            userInfo: nil
        )
        
        guard let eventTap = eventTap else {
            print("Event tap creation failed")
            return
        }
        
        // Add event tap to run loop
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        print("Mouse event monitoring started")
    }
    
    /// Stop mouse event monitoring
    static func stopMouseEventMonitoring() {
        guard let eventTap = eventTap else { return }
        
        CGEvent.tapEnable(tap: eventTap, enable: false)
        CFMachPortInvalidate(eventTap)
        self.eventTap = nil
        
        print("Mouse event monitoring stopped")
    }
}
