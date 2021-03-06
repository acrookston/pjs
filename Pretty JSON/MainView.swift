//
//  MainView.swift
//  PJs
//
//  Created by Andrew C on 6/17/18.
//  Copyright © 2018 Andrew Crookston. All rights reserved.
//

import AppKit

// NOTE: Consider using NSSplitView (for resizing?)

final class MainView: NSView {
    required init?(coder decoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(delegate: ParserInputDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        inputBackground.addSubview(inputView)
        outputBackground.addSubview(outputView)
        inputView.textView.delegate = self
        addSubview(ouputSegmentControl)
        addSubview(inputTitle)
        addSubview(outputTitle)
        addSubview(inputBackground)
        addSubview(outputBackground)
        addSubview(copyButton)
        setupConstraints()
    }

    // MARK: - Public properties

    weak var delegate: ParserInputDelegate?
    var parsingMode: ParserMode = .prettified {
        didSet {
            delegate?.parseText(input: inputView.textView.string, mode: parsingMode)
        }
    }

    // MARK: - View setup

    private func setupConstraints() {
        inputBackground.translatesAutoresizingMaskIntoConstraints = false
        outputBackground.translatesAutoresizingMaskIntoConstraints = false
        inputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.translatesAutoresizingMaskIntoConstraints = false
        inputTitle.translatesAutoresizingMaskIntoConstraints = false
        outputTitle.translatesAutoresizingMaskIntoConstraints = false
        ouputSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        copyButton.translatesAutoresizingMaskIntoConstraints = false

        let spacing: CGFloat = 10
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            ouputSegmentControl.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            ouputSegmentControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            inputTitle.topAnchor.constraint(equalTo: ouputSegmentControl.bottomAnchor, constant: spacing),
            inputTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing),
            inputTitle.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding),

            outputTitle.topAnchor.constraint(equalTo: ouputSegmentControl.bottomAnchor, constant: spacing),
            outputTitle.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: padding),
            outputTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25, constant: 0),

            copyButton.centerYAnchor.constraint(equalTo: outputTitle.centerYAnchor),
            copyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing),

            inputBackground.topAnchor.constraint(equalTo: inputTitle.bottomAnchor, constant: spacing),
            inputBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),
            inputBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing),
            inputBackground.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding),

            inputView.topAnchor.constraint(equalTo: inputBackground.topAnchor, constant: padding),
            inputView.bottomAnchor.constraint(equalTo: inputBackground.bottomAnchor, constant: -padding),
            inputView.leftAnchor.constraint(equalTo: inputBackground.leftAnchor, constant: padding),
            inputView.rightAnchor.constraint(equalTo: inputBackground.rightAnchor, constant: -padding),

            outputBackground.topAnchor.constraint(equalTo: outputTitle.bottomAnchor, constant: spacing),
            outputBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),
            outputBackground.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: padding),
            outputBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing),

            outputView.topAnchor.constraint(equalTo: outputBackground.topAnchor, constant: padding),
            outputView.bottomAnchor.constraint(equalTo: outputBackground.bottomAnchor, constant: -padding),
            outputView.leftAnchor.constraint(equalTo: outputBackground.leftAnchor, constant: padding),
            outputView.rightAnchor.constraint(equalTo: outputBackground.rightAnchor, constant: -padding)
        ])
    }

    // MARK: - actions

    @objc private func didTapSegment(sender: NSSegmentedControl) {
        switch sender.indexOfSelectedItem {
        case 0:
            parsingMode = .prettified
        default:
            parsingMode = .minified
        }
    }

    @objc private func didTapCopy(sender: NSButton) {
        delegate?.copyOutput()
    }

    // MARK: - child view

    private let inputTitle: NSTextField = {
        let view = NSTextField(frame: .zero)
        view.isBezeled = false
        view.isEditable = false
        view.isSelectable = false
        view.drawsBackground = false
        view.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        view.stringValue = NSLocalizedString("Input", comment: "input title")
        return view
    }()

    private let outputTitle: NSTextField = {
        let view = NSTextField(frame: .zero)
        view.isBezeled = false
        view.isEditable = false
        view.isSelectable = false
        view.drawsBackground = false
        view.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        view.stringValue = NSLocalizedString("Output", comment: "output title")
        return view
    }()

    private let ouputSegmentControl: NSSegmentedControl = {
        let strings = [
            NSLocalizedString("Prettified", comment: "prettified segment control"),
            NSLocalizedString("Minimized", comment: "minimized segment control")
        ]
        let segment = NSSegmentedControl(labels: strings,
                                         trackingMode: .selectOne,
                                         target: self,
                                         action: #selector(didTapSegment))
        segment.selectedSegment = 0
        return segment
    }()

    private let inputBackground: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 1
        view.layer?.backgroundColor = NSColor.white.cgColor
        return view
    }()

    private let outputBackground: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 1
        view.layer?.backgroundColor = NSColor(calibratedRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        return view
    }()

    private lazy var copyButton: NSButton = NSButton(title: NSLocalizedString("Copy output", comment: "copy button"),
                                                     target: self,
                                                     action: #selector(didTapCopy))

    let inputView: ScrollTextView = {
        let scrollText = ScrollTextView(frame: .zero)
        scrollText.textView.isEditable = true
        scrollText.textView.isSelectable = true
        scrollText.drawsBackground = false
        return scrollText
    }()

    let outputView: ScrollTextView = {
        let scrollText = ScrollTextView(frame: .zero)
        scrollText.textView.drawsBackground = false
        scrollText.textView.isEditable = false
        scrollText.textView.isSelectable = true
        scrollText.drawsBackground = false
        return scrollText
    }()
}

extension MainView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        delegate?.parseText(input: inputView.textView.string, mode: parsingMode)
    }
}
