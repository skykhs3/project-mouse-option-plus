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
        // 메뉴바 앱으로 변경
        MenuBarExtra("Mouse Option Plus", systemImage: "computermouse") {
            Button("설정 열기") {
                appDelegate.openSettingsWindow()
            }
            
            Divider()
            
            Button("정보") {
                appDelegate.showAbout()
            }
            
            Divider()
            
            Button("종료") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}

// AppDelegate를 통해 앱 시작 시 마우스 모니터링 자동 시작
class AppDelegate: NSObject, NSApplicationDelegate {
    // 설정 윈도우를 강한 참조로 유지 (메모리에서 해제되지 않도록)
    private var settingsWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 앱 시작 - 마우스 이벤트 모니터링 자동 시작")
        DesktopSwitcher.startMouseEventMonitoring()
        
        // Dock 아이콘 숨기기 (메뉴바 전용 앱으로 만들기)
        NSApp.setActivationPolicy(.accessory)
        
        // 앱 시작 시 설정 창 자동으로 열기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openSettingsWindow()
        }
    }
    
    func openSettingsWindow() {
        // 윈도우를 표시하기 위해 일시적으로 regular 모드로 전환
        NSApp.setActivationPolicy(.regular)
        
        // 이미 윈도우가 있으면 활성화
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // 새 윈도우 생성
        let contentView = ContentView()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "설정"
        window.contentView = NSHostingView(rootView: contentView)
        window.center()
        
        // ⭐ 중요: 창이 닫힐 때 자동으로 release되지 않도록 설정
        window.isReleasedWhenClosed = false
        
        // 윈도우 delegate 설정 (창이 닫힐 때 참조 해제)
        window.delegate = self
        
        // 강한 참조로 저장
        self.settingsWindow = window
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Mouse Option Plus"
        alert.informativeText = """
        마우스 제스처로 데스크톱 전환과 브라우저 네비게이션을 제어하는 앱입니다.
        
        버전: 1.0
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "확인")
        alert.runModal()
    }
}

// NSWindowDelegate를 구현하여 창 닫힐 때 처리
extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window == settingsWindow {
            print("설정 창이 닫힙니다")
            // 창을 닫을 때 참조 해제 (메모리 절약)
            settingsWindow = nil
            
            // 창이 닫히면 다시 accessory 모드로 전환 (Dock 아이콘 숨김)
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
