//
//  ParsingController.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import AppKit
import Cartography

final class ScrollTextView: NSScrollView {
    let textView = NSTextView(frame: .zero)

    func configure() {
        hasVerticalScroller = true
        autoresizingMask = [.width, .height]
        textView.minSize = NSSize(width: CGFloat(0.0), height: contentSize.height)
        textView.maxSize = NSSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: contentSize.width, height: CGFloat(Float.greatestFiniteMagnitude))
        disableAllAutomaticBehavior()
        documentView = textView
    }

    func disableAllAutomaticBehavior() {
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

final class ParsingController: NSViewController, NSTextViewDelegate {
    let inputBackground: NSView = {
        let view = NSView(frame: .zero)
        return view
    }()

    let inputView: ScrollTextView = {
        let scrollText = ScrollTextView(frame: .zero)
        scrollText.textView.isEditable = true
        scrollText.textView.isSelectable = true
        scrollText.backgroundColor = .white
        return scrollText
    }()

    let outputView: ScrollTextView = {
        let scrollText = ScrollTextView(frame: .zero)
        scrollText.textView.drawsBackground = false
        scrollText.textView.isEditable = false
        scrollText.textView.isSelectable = true
        return scrollText
    }()

    override func loadView() {
        // Prevents loading from nib
        view = NSView()
    }

    override func viewDidLoad() {
        view.autoresizingMask = [.width, .height]
        view.translatesAutoresizingMaskIntoConstraints = true
        inputView.textView.delegate = self
        inputBackground.addSubview(inputView)
        view.addSubview(inputBackground)
        view.addSubview(outputView)

//        NotificationCenter.default.addObserver(self, selector: #selector(textCopy), name: Notifications.applicationTextCopy.name, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(textPaste), name: Notifications.applicationTextPaste.name, object: nil)
//        NotificationCenter.default.addObserver(forName: Notifications.applicationTextCopy.name, object: self, queue: .main) { [weak self] notification in
//            print("Copying!")
//            guard let strongSelf = self else { return }
//            NSPasteboard.general.setString(strongSelf.outputView.string, forType: .string)
//            print("Copied!")
//        }
//        NotificationCenter.default.addObserver(forName: Notifications.applicationTextPaste.name, object: self, queue: .main) { [weak self] notification in
//            print("pasting!")
//            guard let strongSelf = self else { return }
//
//            if let text = NSPasteboard.general.string(forType: .string) {
//                strongSelf.outputView.string = text
//                print("Pasted!")
//            }
//        }
    }

    override func viewWillAppear() {
        self.view.window?.setFrame(NSRect(x: 0, y: 0, width: 800, height: 600), display: true)
    }

    init(sender: Any?) {
        super.init(nibName: nil, bundle: nil)
        print("VC INIT")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateViewConstraints() {
        constrain(self.view, inputView, outputView, inputBackground) { view, input, output, inputBackground in
            inputBackground.top == view.top + 10
            inputBackground.bottom == view.bottom - 10
            inputBackground.left == view.left + 10
            inputBackground.right == view.centerX - 10

            input.edges == inputBackground.edges

            output.top == view.top + 10
            output.bottom == view.bottom - 10
            output.left == view.centerX + 10
            output.right == view.right - 10
        }
        super.updateViewConstraints()
        view.setNeedsDisplay(.zero)
    }

    func parseInputText() {
        Parser().parse(inputView.textView.string) { [weak self] result in
            switch result {
            case .success(let prettyString):
                self?.outputView.textView.string = prettyString
            case .error(let error):
                print("PARSE ERROR: \(error)")
            }
        }
    }

    // MARK: - NSTextViewDelegate

    func textView(_ textView: NSTextView, shouldChangeTextInRanges affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool {
        parseInputText()
        return true
    }

    // MARK: - NotificationCenter

    @objc func textPaste() {
        if let text = NSPasteboard.general.string(forType: .string) {
            inputView.textView.string = text
            parseInputText()
        }
    }

    @objc func textCopy() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(outputView.textView.string, forType: .string)
        print("Copied!")
    }
}
