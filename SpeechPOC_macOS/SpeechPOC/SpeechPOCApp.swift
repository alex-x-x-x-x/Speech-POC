//
//  SpeechPOCApp.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/25/24.
//

import SwiftUI
import AppKit

@main
struct SpeechPOCApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 800, height: 600)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            let targetSize = NSSize(width: 800, height: 600)
            
            window.setContentSize(targetSize)
            window.minSize = targetSize
            window.maxSize = targetSize
            
            window.styleMask.remove([.resizable, .fullScreen, .miniaturizable])
            
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            
            window.isMovableByWindowBackground = false
            window.collectionBehavior = [.fullScreenNone]
            window.level = .floating
            
            window.center()
    
            window.level = .floating
        }
    }
}


