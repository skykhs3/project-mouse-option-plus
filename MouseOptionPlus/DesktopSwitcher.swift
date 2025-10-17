import Foundation
import CoreGraphics
import AppKit

// Global variables (for access in event callbacks)
private var initialMousePosition: NSPoint = NSPoint.zero
private let minimumDragDistance: CGFloat = 50.0
private var mouseButton2StartPosition: NSPoint = NSPoint.zero
private var mouseButton3StartPosition: NSPoint = NSPoint.zero
private var mouseButton4StartPosition: NSPoint = NSPoint.zero

// Global function to be used as C function pointer
func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    switch type {
    case .otherMouseDown:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ Mouse button pressed - Button number: \(buttonNumber)")
        
        if buttonNumber == 2 {
            mouseButton2StartPosition = NSEvent.mouseLocation
        }
        else if buttonNumber == 3 {
            mouseButton3StartPosition = NSEvent.mouseLocation
            return nil  // Block default browser navigation behavior
        }
        else if buttonNumber == 4 {
//            DesktopSwitcher.toggleFullscreen()
            mouseButton4StartPosition = NSEvent.mouseLocation
            return nil  // Block default browser navigation behavior
        }
        
    case .otherMouseUp:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ Mouse button released - Button number: \(buttonNumber)")
        
        if buttonNumber == 2 {
            let endPosition = NSEvent.mouseLocation
            let deltaX = endPosition.x - mouseButton2StartPosition.x
            
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
            let endPosition = NSEvent.mouseLocation
            let deltaX = endPosition.x - mouseButton3StartPosition.x
            let deltaY = endPosition.y - mouseButton3StartPosition.y
            
            if abs(deltaX) > abs(deltaY) {
                if abs(deltaX) < minimumDragDistance {
                    print("✅ Mouse button 3 simple click - Execute Mission Control")
                    DesktopSwitcher.showLaunchpad()
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
            else {
                if abs(deltaY) < minimumDragDistance {
                    print("✅ Mouse button 3 simple click - Execute Mission Control")
                    DesktopSwitcher.showLaunchpad()
                } else {
                    if deltaY > 0 {
                        print("⬅️ Mouse button 3 Up drag detected - Desktop go up")
                        DesktopSwitcher.showMissionControl()
                    } else{
                        print("➡️ Mouse button 3 Down drag detected - Desktop go down")
                        DesktopSwitcher.showAppExpose()
                    }
                }
            }
        
        }
        // Block default behavior for button 4 and 5
        else if buttonNumber == 4 {
            let endPosition = NSEvent.mouseLocation
            let deltaX = endPosition.x - mouseButton4StartPosition.x
            let deltaY = endPosition.y - mouseButton4StartPosition.y
            
            if abs(deltaX) > abs(deltaY) {
                if abs(deltaX) < minimumDragDistance {
                    print("✅ Mouse button 4 simple click - Open Cursor")
                    DesktopSwitcher.openCursor()
                } else {
                    if deltaX > 0 {
                        print("⬅️ Mouse button 4 Right drag detected - Desktop go left")
                        DesktopSwitcher.switchToPrevious()
                    } else{
                        print("➡️ Mouse button 4 Left drag detected - Desktop go right")
                        DesktopSwitcher.switchToNext()
                    }
                    
                }
            }
            else {
                if abs(deltaY) < minimumDragDistance {
                    print("✅ Mouse button 4 simple click - Open Cursor")
                    DesktopSwitcher.openCursor()
                } else {
                    if deltaY > 0 {
                        print("⬅️ Mouse button 4 Up drag detected - Desktop go up")
                        DesktopSwitcher.showMissionControl()
                    } else{
                        print("➡️ Mouse button 4 Down drag detected - Desktop go down")
                        DesktopSwitcher.showAppExpose()
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
    
    static func toggleFullscreen() {
        let script = """
        tell application "System Events" to key code 3 using {command down, control down}
        """
        runAppleScript(script: script)
    }
    
    static func showMissionControl() {
        let script = """
        tell application "System Events" to key code 160
        """
        runAppleScript(script: script)
    }
    
    static func showLaunchpad() {
        let script = """
        do shell script "open /System/Applications/Launchpad.app"
        """
        runAppleScript(script: script)
    }
    
    static func showAppExpose() {
        let script = """
        tell application "System Events" to key code 125 using {control down}
        """
        runAppleScript(script: script)
    }
    
    // MARK: - Terminal Command Execution
    
    /// Execute terminal command using Process
    static func executeTerminalCommand(_ command: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        
        do {
            try process.run()
            process.waitUntilExit()
            print("Terminal command executed: \(command)")
        } catch {
            print("Error executing terminal command: \(error)")
        }
    }
    
    /// Open Cursor application
    static func openCursor() {
        executeTerminalCommand("open -a Cursor")
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
