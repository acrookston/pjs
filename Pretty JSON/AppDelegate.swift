//
//  AppDelegate.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import Foundation
import Cocoa

extension NSWindow {
    static let desiredSize: CGSize = CGSize(width: 800, height: 600)
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: NSWindowController?
    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.mainMenu = mainMenu
        window = NSWindow(contentRect: .zero,
                          styleMask: [.titled, .closable, .resizable, .miniaturizable],
                          backing: .buffered,
                          defer: false)
        window?.title = "PJs"
        windowController = NSWindowController(window: window)
        window?.contentViewController = MainViewController(sender: nil)
        window?.makeKeyAndOrderFront(nil)
        windowController?.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private lazy var mainMenu: NSMenu = {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem(title: "PJs", action: nil, keyEquivalent: "")
        let appMenu = NSMenu(title: "PJs")
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

        return mainMenu
    }()

    // MARK: - Menu callbacks

    @objc func terminateApplication() {
        NSApp.terminate(nil)
    }

    @objc private func textPaste() {
        NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self)
    }

    @objc private func textCut() {
        NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self)
    }

    @objc private func textCopy() {
        NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self)
    }

    @objc private func textSelectAll() {
        NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self)
    }
}
