//
//  AppDelegate.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import Foundation
import Cocoa

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case applicationTextCopy
    case applicationTextPaste
    case applicationTextSelectAll
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: NSWindowController?
    var window: NSWindow?

    var newWindow: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem(title: "Pretty JSON", action: nil, keyEquivalent: "")
        let appMenu = NSMenu(title: "Pretty JSON")
        appMenu.addItem(withTitle: "Quit", action: #selector(terminateApplication), keyEquivalent: "q")
        appMenuItem.submenu = appMenu

        let editMenuItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "f")
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Copy", action: #selector(textCopy), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(textPaste), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Cut", action: #selector(textCut), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Select All", action: #selector(textSelectAll), keyEquivalent: "a")
        editMenuItem.submenu = editMenu

        mainMenu.addItem(appMenuItem)
        mainMenu.addItem(editMenuItem)

        NSApp.mainMenu = mainMenu

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                          styleMask: [.titled, .closable, .resizable, .miniaturizable],
                          backing: .buffered,
                          defer: false)
        window?.title = "Pretty JSON"
        windowController = NSWindowController(window: window)
        window?.contentViewController = ParsingController(sender: nil)
        window?.makeKeyAndOrderFront(nil)
        windowController?.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Menu callbacks

    @objc func terminateApplication() {
        NSApp.terminate(nil)
    }

    @objc func textPaste() {
        NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self)
//        NotificationCenter.default.post(name: Notifications.applicationTextPaste.name, object: nil)
    }

    @objc func textCut() {
        NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self)
    }

    @objc func textCopy() {
        NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self)
//        NotificationCenter.default.post(name: Notifications.applicationTextCopy.name, object: nil)
    }

    @objc func textSelectAll() {
        NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self)
//        NotificationCenter.default.post(name: Notifications.applicationTextSelectAll.name, object: nil)
    }
}
