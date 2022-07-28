//
//  CountBarApp.swift
//  CountBar
//
//  Created by Ron Friedman on 2022-07-27.
//

import SwiftUI

@main
struct CountBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var statusBar: WordCountBar?
    var pasteBoard = NSPasteboard.general
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        //Initialize status bar with contents of clipboard
        statusBar = WordCountBar.init(withText: pasteBoard.string(forType: NSPasteboard.PasteboardType.string) ?? "")
        
        //Close the default window
        if let window = NSApplication.shared.windows.first {
                    window.close()
        }
        
        WatchPasteboard{
            //Update status bar when pasteboard changes
            if self.statusBar != nil {
                self.statusBar!.text = $0
                self.statusBar!.updateCount()
        }
            
            
        }
    }
    
    func WatchPasteboard(copied: @escaping (_ copiedString:String) -> Void) {
        //From https://stackoverflow.com/a/60249388
        
        let pasteboard = NSPasteboard.general
        var changeCount = NSPasteboard.general.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let copiedString = pasteboard.string(forType: .string) {
                if pasteboard.changeCount != changeCount {
                    copied(copiedString)
                    changeCount = pasteboard.changeCount
                }
            }
        }
    }
    
}
