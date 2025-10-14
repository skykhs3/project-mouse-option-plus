//
//  MouseOptionPlusApp.swift
//  MouseOptionPlus
//
//  Created by USER on 10/12/25.
//

import SwiftUI

@main
struct MouseOptionPlusApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Menu bar app
        MenuBarExtra("Mouse Option Plus", systemImage: "computermouse") {
            Button("Open Settings") {
                appDelegate.openSettingsWindow()
            }
            
            Divider()
            
            Button("About") {
                appDelegate.showAbout()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}

// AppDelegate to automatically start mouse monitoring on app launch
class AppDelegate: NSObject, NSApplicationDelegate {
    // Keep strong reference to settings window (prevent memory deallocation)
    private var settingsWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 App started - Mouse event monitoring automatically enabled")
        DesktopSwitcher.startMouseEventMonitoring()
        
        // Hide Dock icon (make it menu bar only app)
        NSApp.setActivationPolicy(.accessory)
        
        // Automatically open settings window on app launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openSettingsWindow()
        }
    }
    
    func openSettingsWindow() {
        // Temporarily switch to regular mode to show window
        NSApp.setActivationPolicy(.regular)
        
        // If window already exists, activate it
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create new window
        let contentView = ContentView()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Settings"
        window.contentView = NSHostingView(rootView: contentView)
        window.center()
        
        // ⭐ Important: Prevent automatic release when window is closed
        window.isReleasedWhenClosed = false
        
        // Set window delegate (to release reference when closed)
        window.delegate = self
        
        // Save with strong reference
        self.settingsWindow = window
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Mouse Option Plus"
        alert.informativeText = """
        Control desktop switching and browser navigation with mouse gestures.
        
        Version: 1.0
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

// Implement NSWindowDelegate to handle window closing
extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window == settingsWindow {
            print("Settings window closing")
            // Release reference when closing window (save memory)
            settingsWindow = nil
            
            // Switch back to accessory mode when window closes (hide Dock icon)
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
