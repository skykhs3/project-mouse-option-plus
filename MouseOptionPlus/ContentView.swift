// ContentView.swift
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Desktop switch Test")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // Desktop switch buttons
            VStack(spacing: 15) {
                Button("Left Desktop (←)") {
                    DesktopSwitcher.switchToPrevious()
                }
                .font(.title)
                
                Button("Right Desktop (→)") {
                    DesktopSwitcher.switchToNext()
                }
                .font(.title)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            // Mouse gesture features
            VStack(spacing: 15) {
                Text("Mouse")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ Middle Mouse Button (Button 3) Drag")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Switch Desktop (Left: Next, Right: Previous)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ Middle Mouse Button (Button 3) Click")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Show Mission Control")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ Mouse Button 4 Click")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Toggle Full Screen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("🖱️ Mouse Button 5 Drag")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Browser Navigation (Left: Back, Right: Forward)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 10)
                
                Text("Press mouse buttons to see button numbers in Xcode console")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
            }
            
            // Status indicator
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Mouse Monitoring Active")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .padding(.top, 5)
        }
        .padding(40)
        .onAppear(perform: checkAccessibilityPermissions) // Check permissions on appear
    }
    
    // Check accessibility permissions and prompt user if needed
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        if isTrusted {
            print("Accessibility permission granted.")
        } else {
            print("Accessibility permission required.")
        }
    }
}

#Preview {
    ContentView()
}
