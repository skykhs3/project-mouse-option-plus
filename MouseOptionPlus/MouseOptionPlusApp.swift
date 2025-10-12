//
//  awesomekeyboardApp.swift
//  awesomekeyboard
//
//  Created by USER on 10/12/25.
//

import SwiftUI

@main
struct awesomekeyboardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("🚀 앱 시작 - 마우스 이벤트 모니터링 자동 시작")
                    DesktopSwitcher.startMouseEventMonitoring()
                }
        }
    }
}
