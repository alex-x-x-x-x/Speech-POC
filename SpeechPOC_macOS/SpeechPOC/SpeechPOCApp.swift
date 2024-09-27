//
//  SpeechPOCApp.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/25/24.
//

import SwiftUI

@main
struct SpeechPOCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 800, height: 600)
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.setContentSize(NSSize(width: 800, height: 600))
                        window.minSize = NSSize(width: 800, height: 600)
                        window.maxSize = NSSize(width: 800, height: 600)
                        
                        window.styleMask.remove([.resizable, .fullScreen, .fullSizeContentView])
                        
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                        window.isMovableByWindowBackground = false
                        window.collectionBehavior = [.fullScreenNone]
                    }
                }
        }
    }
}

