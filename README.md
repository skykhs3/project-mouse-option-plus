# Mouse Option+

A Swift app for macOS that enables intuitive desktop switching, browser navigation, fullscreen toggling, and Mission Control using mouse buttons and gestures.

## 🎯 Key Features

### 1. Desktop Switching
- **Mouse Wheel Button (3) + Drag**: Switch between desktops
  - Left drag → Next desktop
  - Right drag → Previous desktop

### 2. Browser Navigation
- **Right-click Button (2) + Drag**: Browser back/forward navigation
  - Left drag → Go back (Cmd + ←)
  - Right drag → Go forward (Cmd + →)
  - **Feature**: Executes only once based on total drag distance when button is released

### 3. Mission Control
- **Mouse Wheel Button (3) Simple Click**: Show Mission Control
  - Only executes when drag distance is less than 50 pixels
  - Smart detection to distinguish from drag gestures

### 4. Fullscreen Toggle
- **Mouse Button (4) Click**: Toggle fullscreen (Cmd + Ctrl + F)

## 🚀 Installation & Setup

### Requirements
- macOS 10.15 (Catalina) or later
- Xcode 12.0 or later
- Accessibility permissions (automatically requested)

### Installation Steps
1. Clone or download the project
2. Open `awesomekeyboard.xcodeproj` in Xcode
3. Build and run the project
4. Grant accessibility permissions

### Permission Setup
The app will request accessibility permissions on first launch:
1. **System Preferences** → **Security & Privacy** → **Privacy**
2. Select **Accessibility** tab
3. Enable checkbox for **awesomekeyboard** app

## 🎮 Usage Guide

### Basic Usage
1. Launch the app (mouse event monitoring starts automatically)
2. Perform desired mouse button operations
3. Check real-time logs in console

### Detailed Usage

#### Desktop Switching
```
Press mouse wheel button → Drag left/right → Release button
```

#### Browser Navigation
```
Press right-click button → Drag left/right → Release button
```

#### Mission Control
```
Simple click mouse wheel button (without dragging)
```

#### Fullscreen Toggle
```
Click mouse button 4
```

## ⚙️ Configuration

### Drag Distance Settings
Minimum drag distance can be adjusted in `DesktopSwitcher.swift`:
```swift
private let minimumDragDistance: CGFloat = 50.0 // in pixels
```

### Key Code Customization
Key codes for each function can be modified in `DesktopSwitcher.swift`:
- Desktop switching: `key code 124/123` (arrow keys)
- Browser navigation: `key code 33/30` (←/→ keys)
- Fullscreen: `key code 3` (F key)
- Mission Control: `key code 160` (F3 key)

## 📊 Logging & Debugging

The app outputs detailed logs to the console:

```
🖱️ Mouse button press detected - Button number: 3
✅ Mouse button 3 pressed - Desktop switching mode started
🖱️ Mouse drag detected (button 3) - X movement: -75.0
⬅️ Left drag detected - Switching to next desktop
✅ Mouse button 3 released - Desktop switching mode ended
```

### Log Levels
- **🖱️**: Mouse event detection
- **✅**: Button state changes
- **⬅️➡️**: Drag direction and action execution
- **📏**: Insufficient drag distance notification
- **⏰**: Delay status (browser navigation)

## 🔧 Tech Stack

- **Language**: Swift 5.0+
- **Frameworks**: SwiftUI, AppKit, CoreGraphics
- **Event Handling**: CGEventTap
- **Script Execution**: NSAppleScript

## 📁 Project Structure

```
awesomekeyboard/
├── awesomekeyboardApp.swift      # App entry point
├── ContentView.swift             # Main UI
├── DesktopSwitcher.swift         # Core functionality
├── Assets.xcassets/              # App resources
└── Info.plist                   # App configuration
```

## 🐛 Troubleshooting

### Accessibility Permission Errors
- Verify accessibility permissions are enabled in System Preferences
- Restart the app to re-request permissions

### Mouse Button Not Detected
- Check if mouse drivers are up to date
- Test with a different mouse
- Check button numbers in console logs

### Features Not Working
- Verify AppleScript execution permissions
- Check app permissions in System Preferences → Security & Privacy → Privacy → Accessibility

## 📝 License

This project is an open-source project for personal use.

## 🤝 Contributing

Please create an issue for bug reports or feature suggestions.

## 📞 Support

If you encounter problems or have questions, please create an issue.

---

**Warning**: This app requires system-level accessibility permissions, so only download and use from trusted sources.

----

# Mouse Option+

macOS에서 마우스 버튼과 제스처를 활용하여 데스크톱 전환, 브라우저 네비게이션, 전체화면 토글, 미션 컨트롤 등의 기능을 직관적으로 사용할 수 있는 Swift 앱입니다.

## 🎯 주요 기능

### 1. 데스크톱 전환
- **마우스 휠 버튼(3번) + 드래그**: 데스크톱 간 전환
  - 왼쪽 드래그 → 다음 데스크톱
  - 오른쪽 드래그 → 이전 데스크톱

### 2. 브라우저 네비게이션
- **우클릭 버튼(2번) + 드래그**: 브라우저 뒤로가기/앞으로가기
  - 왼쪽 드래그 → 뒤로가기 (Cmd + ←)
  - 오른쪽 드래그 → 앞으로가기 (Cmd + →)
  - **특징**: 버튼을 누르고 뗄 때의 총 이동 거리로 한 번만 실행

### 3. 미션 컨트롤
- **마우스 휠 버튼(3번) 단순 클릭**: 미션 컨트롤 표시
  - 드래그 거리가 50픽셀 미만일 때만 실행
  - 드래그와 구분하여 스마트하게 감지

### 4. 전체화면 토글
- **마우스 버튼(4번) 클릭**: 전체화면 토글 (Cmd + Ctrl + F)

## 🚀 설치 및 실행

### 요구사항
- macOS 10.15 (Catalina) 이상
- Xcode 12.0 이상
- 접근성 권한 (자동으로 요청됨)

### 설치 방법
1. 프로젝트 클론 또는 다운로드
2. Xcode에서 `awesomekeyboard.xcodeproj` 열기
3. 프로젝트 빌드 및 실행
4. 접근성 권한 허용

### 권한 설정
앱을 처음 실행하면 접근성 권한을 요청합니다:
1. **시스템 환경설정** → **보안 및 개인 정보 보호** → **개인 정보 보호**
2. **접근성** 탭 선택
3. **awesomekeyboard** 앱 체크박스 활성화

## 🎮 사용 방법

### 기본 사용법
1. 앱 실행 (자동으로 마우스 이벤트 모니터링 시작)
2. 원하는 마우스 버튼 조작 수행
3. 콘솔에서 실시간 로그 확인 가능

### 상세 사용법

#### 데스크톱 전환
```
마우스 휠 버튼 누르기 → 마우스 좌우 드래그 → 버튼 떼기
```

#### 브라우저 네비게이션
```
우클릭 버튼 누르기 → 마우스 좌우 드래그 → 버튼 떼기
```

#### 미션 컨트롤
```
마우스 휠 버튼 단순 클릭 (드래그 없이)
```

#### 전체화면 토글
```
마우스 4번 버튼 클릭
```

## ⚙️ 설정

### 드래그 거리 설정
최소 드래그 거리는 `DesktopSwitcher.swift`에서 조정 가능:
```swift
private let minimumDragDistance: CGFloat = 50.0 // 픽셀 단위
```

### 키 코드 커스터마이징
각 기능의 키 코드는 `DesktopSwitcher.swift`에서 수정 가능:
- 데스크톱 전환: `key code 124/123` (화살표 키)
- 브라우저 네비게이션: `key code 33/30` (←/→ 키)
- 전체화면: `key code 3` (F 키)
- 미션 컨트롤: `key code 160` (F3 키)

## 📊 로그 및 디버깅

앱은 상세한 로그를 콘솔에 출력합니다:

```
🖱️ 마우스 버튼 눌림 감지 - 버튼 번호: 3
✅ 마우스 버튼 3번 눌림 - 데스크톱 전환 모드 시작
🖱️ 마우스 드래그 감지 (버튼 3번) - X 이동: -75.0
⬅️ 왼쪽 드래그 감지 - 다음 데스크톱으로 전환
✅ 마우스 버튼 3번 떼어짐 - 데스크톱 전환 모드 종료
```

### 로그 레벨
- **🖱️**: 마우스 이벤트 감지
- **✅**: 버튼 상태 변경
- **⬅️➡️**: 드래그 방향 및 액션 실행
- **📏**: 드래그 거리 부족 알림
- **⏰**: 딜레이 상태 (브라우저 네비게이션)

## 🔧 기술 스택

- **언어**: Swift 5.0+
- **프레임워크**: SwiftUI, AppKit, CoreGraphics
- **이벤트 처리**: CGEventTap
- **스크립트 실행**: NSAppleScript

## 📁 프로젝트 구조

```
awesomekeyboard/
├── awesomekeyboardApp.swift      # 앱 진입점
├── ContentView.swift             # 메인 UI
├── DesktopSwitcher.swift         # 핵심 기능 구현
├── Assets.xcassets/              # 앱 리소스
└── Info.plist                   # 앱 설정
```

## 🐛 문제 해결

### 접근성 권한 오류
- 시스템 환경설정에서 접근성 권한이 활성화되어 있는지 확인
- 앱을 재시작하여 권한 재요청

### 마우스 버튼이 감지되지 않음
- 마우스 드라이버가 최신 버전인지 확인
- 다른 마우스로 테스트
- 콘솔 로그에서 버튼 번호 확인

### 기능이 작동하지 않음
- AppleScript 실행 권한 확인
- 시스템 환경설정 → 보안 및 개인 정보 보호 → 개인 정보 보호 → 접근성에서 앱 권한 확인

## 📝 라이선스

이 프로젝트는 개인 사용을 위한 오픈소스 프로젝트입니다.

## 🤝 기여하기

버그 리포트나 기능 제안은 이슈로 등록해 주세요.

## 📞 지원

문제가 발생하거나 질문이 있으시면 이슈를 생성해 주세요.

---

**주의**: 이 앱은 시스템 레벨의 접근성을 요구하므로 신뢰할 수 있는 소스에서만 다운로드하여 사용하세요.

