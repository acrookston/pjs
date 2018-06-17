//
//  MainViewController.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import AppKit

final class MainViewController: NSViewController, NSTextViewDelegate {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(sender: Any?) { super.init(nibName: nil, bundle: nil) }

    // MARK: - properties

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

    // MARK: - View loading

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
        setupConstraints()
    }

    override func viewDidAppear() {
        let size: CGFloat = 800
        let screen = NSScreen.main?.frame.size ?? .zero
        let origin = CGPoint(x: (screen.width - size) / 2, y: (screen.height - size) / 2)
        let frameSize = CGSize(width: size, height: size)
        self.view.window?.setFrame(NSRect(origin: origin, size: frameSize), display: true)
    }

    private func setupConstraints() {
        inputBackground.translatesAutoresizingMaskIntoConstraints = false
        inputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            inputBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            inputBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            inputBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            inputBackground.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -(padding / 2)),

            inputView.topAnchor.constraint(equalTo: inputBackground.topAnchor),
            inputView.bottomAnchor.constraint(equalTo: inputBackground.bottomAnchor),
            inputView.leftAnchor.constraint(equalTo: inputBackground.leftAnchor),
            inputView.rightAnchor.constraint(equalTo: inputBackground.rightAnchor),

            outputView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            outputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            outputView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: (padding / 2)),
            outputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding)
        ])
    }

    // MARK: - NSTextViewDelegate

    func textDidChange(_ notification: Notification) {
        parseInputText()
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

    // MARK: - actions

    private func parseInputText() {
        Parser().parse(inputView.textView.string) { [weak self] result in
            switch result {
            case .success(let prettyString):
                self?.outputView.textView.string = prettyString
            case .error(let error):
                print("PARSE ERROR: \(error)")
            }
        }
    }
}

final class PlainTextView: NSTextView {
    override func paste(_ sender: Any?) {
        pasteAsPlainText(sender)
    }
}
