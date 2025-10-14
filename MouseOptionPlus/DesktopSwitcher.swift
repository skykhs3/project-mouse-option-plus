import Foundation
import CoreGraphics
import AppKit

// 전역 변수들 (이벤트 콜백에서 접근하기 위해)
private var isMouseButton3Pressed = false
private var isMouseButton2Pressed = false
private var initialMousePosition: NSPoint = NSPoint.zero
private let minimumDragDistance: CGFloat = 50.0
private var mouseButton2StartPosition: NSPoint = NSPoint.zero
private var mouseButton3StartPosition: NSPoint = NSPoint.zero
private var mouseButton3HasDragged = false

// C 함수 포인터로 사용할 전역 함수
func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    switch type {
    case .otherMouseDown:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ 마우스 버튼 눌림 감지 - 버튼 번호: \(buttonNumber)")
        
        // 마우스 버튼 2번 (우클릭)이 눌렸는지 확인
        if buttonNumber == 2 {
            isMouseButton2Pressed = true
            mouseButton2StartPosition = NSEvent.mouseLocation
            print("✅ 마우스 버튼 2번 눌림 - 브라우저 네비게이션 모드 시작")
        }
        // 마우스 버튼 3번 (휠 클릭)이 눌렸는지 확인
        else if buttonNumber == 3 {
            isMouseButton3Pressed = true
            mouseButton3StartPosition = NSEvent.mouseLocation
            mouseButton3HasDragged = false
            print("✅ 마우스 버튼 3번 눌림 - 데스크톱 전환 모드 시작")
        }
        // 마우스 버튼 4번이 눌렸는지 확인
        else if buttonNumber == 4 {
            print("✅ 마우스 버튼 4번 눌림 - 전체화면 토글")
            DesktopSwitcher.toggleFullscreen()
        }
        
    case .otherMouseUp:
        let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
        print("🖱️ 마우스 버튼 떼어짐 감지 - 버튼 번호: \(buttonNumber)")
        
        if buttonNumber == 2 {
            isMouseButton2Pressed = false
            
            // 마우스 버튼 2번을 뗄 때 거리 계산하여 브라우저 네비게이션 실행
            let endPosition = NSEvent.mouseLocation
            let deltaX = endPosition.x - mouseButton2StartPosition.x
            
            print("🖱️ 마우스 버튼 2번 떼어짐 - 총 이동 거리: \(deltaX)")
            
            // 최소 드래그 거리 확인
            if abs(deltaX) >= minimumDragDistance {
                if deltaX > 0 {
                    // 오른쪽으로 드래그 - 뒤로가기
                    print("⬅️ 오른쪽 드래그 감지 - 브라우저 뒤로가기")
                    DesktopSwitcher.browserGoBack()
                } else {
                    // 왼쪽으로 드래그 - 앞으로가기
                    print("➡️ 왼쪽 드래그 감지 - 브라우저 앞으로가기")
                    DesktopSwitcher.browserGoForward()
                }
                    
            } else {
                print("📏 드래그 거리 부족 - 최소 거리: \(minimumDragDistance), 실제 거리: \(abs(deltaX))")
            }
            
            print("✅ 마우스 버튼 2번 떼어짐 - 브라우저 네비게이션 모드 종료")
        }
        else if buttonNumber == 3 {
            isMouseButton3Pressed = false
            
            // 마우스 3번 버튼을 뗄 때 드래그가 없었다면 미션 컨트롤 실행
            if !mouseButton3HasDragged {
                let endPosition = NSEvent.mouseLocation
                let deltaX = endPosition.x - mouseButton3StartPosition.x
                
                // 드래그 거리가 최소 거리보다 작으면 단순 클릭으로 간주
                if abs(deltaX) < minimumDragDistance {
                    print("🖱️ 마우스 버튼 3번 단순 클릭 - 미션 컨트롤 실행")
                    DesktopSwitcher.showMissionControl()
                } else {
                    if deltaX > 0 {
                        DesktopSwitcher.switchToNext()
                    }
                    
                
                }
            }
            
            print("✅ 마우스 버튼 3번 떼어짐 - 데스크톱 전환 모드 종료")
        }
        
//    case .otherMouseDragged:
//        let currentMousePosition = NSEvent.mouseLocation
//        let deltaX = currentMousePosition.x - initialMousePosition.x
//        
//        // 마우스 버튼 2번은 드래그 중에는 처리하지 않음 (버튼을 뗄 때만 처리)
//        if isMouseButton2Pressed {
//            // 드래그 중에는 로그만 출력 (실제 액션은 버튼을 뗄 때 실행)
//            print("🖱️ 마우스 드래그 중 (버튼 2번) - 현재 이동: \(deltaX)")
//        }
//        // 마우스 버튼 3번이 눌린 상태에서 데스크톱 전환 처리 (기존 방식 유지)
//        else if isMouseButton3Pressed {
//            let deltaX3 = currentMousePosition.x - mouseButton3StartPosition.x
//            
//            // 드래그가 시작되었음을 표시
//            if abs(deltaX3) >= minimumDragDistance {
//                mouseButton3HasDragged = true
//                print("🖱️ 마우스 드래그 감지 (버튼 3번) - X 이동: \(deltaX3)")
//                
//                if deltaX3 < 0 {
//                    // 왼쪽으로 드래그 - 다음 데스크톱
//                    print("⬅️ 왼쪽 드래그 감지 - 다음 데스크톱으로 전환")
//                    DesktopSwitcher.switchToNext()
//                } else {
//                    // 오른쪽으로 드래그 - 이전 데스크톱
//                    print("➡️ 오른쪽 드래그 감지 - 이전 데스크톱으로 전환")
//                    DesktopSwitcher.switchToPrevious()
//                }
//                
//                // 드래그 완료 후 초기 위치 업데이트 (연속 드래그 방지)
//                mouseButton3StartPosition = currentMousePosition
//            }
//        }
//        
    default:
        break
    }
    
    // 원본 이벤트를 그대로 전달
    return Unmanaged.passUnretained(event)
}

class DesktopSwitcher {
    
    // 마우스 이벤트 모니터링을 위한 변수들
    private static var eventTap: CFMachPort?

    // ✅ '다음' 데스크톱 전환
    static func switchToNext() {
        let script = """
        tell application "System Events" to key code 124 using {control down}
        """
        runAppleScript(script: script)
    }

    // ✅ '이전' 데스크톱 전환 (AppleScript 사용하도록 수정)
    static func switchToPrevious() {
        let script = """
        tell application "System Events" to key code 123 using {control down}
        """
        runAppleScript(script: script)
    }
    
    // ✅ 'static'을 추가하여 클래스 메서드로 변경
    private static func runAppleScript(script: String) {
        // NSAppleScript 객체를 생성합니다.
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            // 스크립트를 실행합니다.
            appleScript.executeAndReturnError(&error)
            
            if let err = error {
                print("AppleScript 오류: \(err)")
            } else {
                print("AppleScript 실행 성공: \(script)")
            }
        }
    }
    
    // MARK: - 브라우저 네비게이션 기능
    
    /// 브라우저 뒤로가기
    static func browserGoBack() {
        let script = """
        tell application "System Events" to key code 33 using {command down}
        """
        runAppleScript(script: script)
    }
    
    /// 브라우저 앞으로가기
    static func browserGoForward() {
        let script = """
        tell application "System Events" to key code 30 using {command down}
        """
        runAppleScript(script: script)
    }
    
    // MARK: - 전체화면 및 미션 컨트롤 기능
    
    /// 전체화면 토글
    static func toggleFullscreen() {
        let script = """
        tell application "System Events" to key code 3 using {command down, control down}
        """
        runAppleScript(script: script)
    }
    
    /// 미션 컨트롤 표시
    static func showMissionControl() {
        let script = """
        tell application "System Events" to key code 160
        """
        runAppleScript(script: script)
    }



    // MARK: - 마우스 드래그로 데스크톱 전환 기능
    
    /// 마우스 이벤트 모니터링 시작
    static func startMouseEventMonitoring() {
        // 이미 모니터링 중이면 중복 시작하지 않음
        guard eventTap == nil else { return }
        
        // 접근성 권한 확인
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        guard isTrusted else {
            print("접근성 권한이 필요합니다.")
            return
        }
        
        // 이벤트 탭 생성 (마우스 이벤트 감지)
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
            print("이벤트 탭 생성 실패")
            return
        }
        
        // 이벤트 탭을 실행 루프에 추가
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        print("마우스 이벤트 모니터링 시작됨")
    }
    
    /// 마우스 이벤트 모니터링 중지
    static func stopMouseEventMonitoring() {
        guard let eventTap = eventTap else { return }
        
        CGEvent.tapEnable(tap: eventTap, enable: false)
        CFMachPortInvalidate(eventTap)
        self.eventTap = nil
        
        print("마우스 이벤트 모니터링 중지됨")
    }
}
