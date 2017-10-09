//
//  NSViewExtensions.swift
//  Pretty JSON
//
//  Created by Andrew C on 10/8/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import AppKit

extension NSView {
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }

        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
