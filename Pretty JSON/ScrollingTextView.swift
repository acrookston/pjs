//
//  ScrollingTextView.swift
//  PJs
//
//  Created by Andrew C on 6/16/18.
//  Copyright © 2018 Andrew Crookston. All rights reserved.
//

import AppKit

final class ScrollTextView: NSScrollView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        configure()
    }

    let textView = PlainTextView(frame: .zero)

    private func configure() {
        hasVerticalScroller = true
        textView.font = bestFont()
        textView.minSize = NSSize(width: CGFloat(0.0), height: contentSize.height)
        textView.maxSize = NSSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: contentSize.width, height: CGFloat(Float.greatestFiniteMagnitude))
        textView.disableAutomaticBehavior()
        documentView = textView
    }

    private func bestFont() -> NSFont {
        if let font = NSFont(name: "IMBPlexMono-Regular", size: NSFont.systemFontSize) { return font }
        if let font = NSFont(name: "AndaleMono", size: NSFont.systemFontSize) { return font }
        if let font = NSFont(name: "PTMono-Regular", size: NSFont.systemFontSize) { return font }
        return NSFont.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
    }
}

final class PlainTextView: NSTextView {
    override func paste(_ sender: Any?) {
        pasteAsPlainText(sender)
    }
}

extension NSTextView {
    func disableAutomaticBehavior() {
        isContinuousSpellCheckingEnabled = false
        isAutomaticTextReplacementEnabled = false
        isAutomaticDataDetectionEnabled = false
        isAutomaticQuoteSubstitutionEnabled = false
        isAutomaticDashSubstitutionEnabled = false
        isAutomaticLinkDetectionEnabled = false
        if #available(OSX 10.12.2, *) {
            isAutomaticTextCompletionEnabled = false
        }
    }
}
