// ContentView.swift
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("데스크톱 전환 도구")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // 기존 버튼들
            VStack(spacing: 15) {
                Button("이전 데스크톱 (←)") {
                    DesktopSwitcher.switchToPrevious()
                }
                .font(.title)
                
                Button("다음 데스크톱 (→)") {
                    DesktopSwitcher.switchToNext()
                }
                .font(.title)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            // 마우스 드래그 기능 설명
            VStack(spacing: 15) {
                Text("마우스 드래그 기능")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ 마우스 휠 버튼(3번) + 드래그")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("데스크톱 전환 (왼쪽: 다음, 오른쪽: 이전)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ 우클릭 버튼(2번) + 드래그")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("브라우저 네비게이션 (왼쪽: 뒤로가기, 오른쪽: 앞으로가기)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ 마우스 휠 버튼(3번) 클릭")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("미션 컨트롤 표시")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ 마우스 버튼(4번) 클릭")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("전체화면 토글")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                Text("마우스 버튼을 눌러보면 콘솔에 버튼 번호가 출력됩니다")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
            }
            
            // 상태 표시
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("마우스 모니터링 자동 활성화됨")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .padding(.top, 5)
        }
        .padding(40)
        .onAppear(perform: checkAccessibilityPermissions) // 앱이 나타날 때 권한 확인
    }
    
    // 손쉬운 사용 권한이 있는지 확인하고, 없으면 사용자에게 요청하는 함수
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        if isTrusted {
            print("손쉬운 사용 권한이 허용되었습니다.")
        } else {
            print("손쉬운 사용 권한이 필요합니다.")
        }
    }
}

#Preview {
    ContentView()
}
