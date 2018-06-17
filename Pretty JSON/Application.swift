//
//  Application.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import AppKit

@objc final class Application: NSApplication {
    private let realDelegate = AppDelegate()

    override func run() {
        let app = NSApplication.shared
        app.delegate = realDelegate
        app.registerServicesMenuSendTypes([NSPasteboard.PasteboardType.string], returnTypes: [NSPasteboard.PasteboardType.string])
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        super.run()
    }

    override func sendEvent(_ event: NSEvent) {
        if event.type == .keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue == NSEvent.ModifierFlags.command.rawValue) {
                guard let key = event.charactersIgnoringModifiers else { return }
                switch key.lowercased() {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return }
//                case "z":
//                    if NSApp.sendAction(#selector(UndoManager.undo), to:nil, from:self) { return }
                case "a":
                    if NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self) { return }
                default:
                    break
                }
            } else if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue == (NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)) {
                if event.charactersIgnoringModifiers == "Z" {
//                    if NSApp.sendAction(#selector(UndoManager.redo), to:nil, from:self) { return }
                }
            }
        }
        return super.sendEvent(event)
    }
}
