//
//  WordCountBar.swift
//  CountBar
//
//  Created by Ron Friedman on 2022-07-27.
//

import AppKit

class WordCountBar{
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    public var text: String
    private var wordCount: Int = 0
    private var charCount: Int = 0
    private var showCharCount = true
    
    init(withText: String) {
        //Initializes the status bar, counting the words in given string
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        text = withText
        
        updateCount()
        
        //Set status image
        if let statusBarButton = statusItem.button{
            statusBarButton.image = NSImage(systemSymbolName: "pencil.and.outline", accessibilityDescription: nil)
            statusBarButton.imagePosition = NSControl.ImagePosition.imageLeft
        }
        
        //Set up menu
        let mainMenu = NSMenu()
        
        let charToggle = NSMenuItem()
        charToggle.title = "Show Character Count"
        charToggle.state = NSControl.StateValue.on
        charToggle.target = self
        charToggle.action = #selector(WordCountBar.toggleCharCount)
        
        let quitButton = NSMenuItem()
        quitButton.title = "Quit"
        quitButton.target = self
        quitButton.action = #selector(WordCountBar.quitOut)
        quitButton.keyEquivalent = "q"
        
        mainMenu.addItem(charToggle)
        mainMenu.addItem(quitButton)
        statusItem.menu = mainMenu
    }
    
    @objc func quitOut(){
        NSApplication.shared.terminate(nil)
    }
    
    @objc func toggleCharCount(_ sender: NSMenuItem){
        if(sender.state == NSControl.StateValue.on){
            sender.state = NSControl.StateValue.off
        }else{
            sender.state = NSControl.StateValue.on
        }
        
        showCharCount = !showCharCount
        updateCount()
    }
    
    func updateCount(){
        //Counts words and updates status bar display
        countWords()
        if let statusBarButton = statusItem.button{
            let title = String(wordCount)+(showCharCount ? " / "+String(charCount):"")
            statusBarButton.title = title
        }
    }
    
    func countWords(){
        //Yucky one-liner; splits on spaces and newlines, removes empty "words", and counts
        wordCount = text.components(separatedBy: .whitespacesAndNewlines).filter{!$0.isEmpty }.count
        
        //Removes newlines and counts remaining characters
        charCount = text.components(separatedBy: .newlines).joined().count
    }

}
