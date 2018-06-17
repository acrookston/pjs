//
//  ScrollingTextView.swift
//  PJs
//
//  Created by Andrew C on 6/16/18.
//  Copyright © 2018 Andrew Crookston. All rights reserved.
//

import AppKit

final class ScrollTextView: NSScrollView {
    let textView = PlainTextView(frame: .zero)

    private func configure() {
        hasVerticalScroller = true
        autoresizingMask = [.width, .height]
        textView.font = bestFont()
        textView.minSize = NSSize(width: CGFloat(0.0), height: contentSize.height)
        textView.maxSize = NSSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: contentSize.width, height: CGFloat(Float.greatestFiniteMagnitude))
        disableAutomaticBehavior(on: textView)
        documentView = textView
    }

    private func bestFont() -> NSFont {
        if let font = NSFont(name: "IMBPlexMono-Regular", size: NSFont.systemFontSize) { return font }
        if let font = NSFont(name: "AndaleMono", size: NSFont.systemFontSize) { return font }
        if let font = NSFont(name: "PTMono-Regular", size: NSFont.systemFontSize) { return font }
        return NSFont.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
    }

    private func disableAutomaticBehavior(on textView: NSTextView) {
        textView.isContinuousSpellCheckingEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticDataDetectionEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        if #available(OSX 10.12.2, *) {
            textView.isAutomaticTextCompletionEnabled = false
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        configure()
    }
}
