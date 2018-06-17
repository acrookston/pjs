//
//  MainView.swift
//  PJs
//
//  Created by Andrew C on 6/17/18.
//  Copyright © 2018 Andrew Crookston. All rights reserved.
//

import AppKit

final class MainView: NSView {
    required init?(coder decoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(delegate: NSTextViewDelegate) {
        super.init(frame: .zero)
        inputBackground.addSubview(inputView)
        outputBackground.addSubview(outputView)
        inputView.textView.delegate = delegate
        addSubview(inputBackground)
        addSubview(outputBackground)
        setupConstraints()
    }

    private func setupConstraints() {
        inputBackground.translatesAutoresizingMaskIntoConstraints = false
        outputBackground.translatesAutoresizingMaskIntoConstraints = false
        inputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            inputBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            inputBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            inputBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            inputBackground.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -(padding / 2)),

            inputView.topAnchor.constraint(equalTo: inputBackground.topAnchor, constant: (padding / 2)),
            inputView.bottomAnchor.constraint(equalTo: inputBackground.bottomAnchor, constant: -(padding / 2)),
            inputView.leftAnchor.constraint(equalTo: inputBackground.leftAnchor, constant: (padding / 2)),
            inputView.rightAnchor.constraint(equalTo: inputBackground.rightAnchor, constant: -(padding / 2)),

            outputBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            outputBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            outputBackground.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: (padding / 2)),
            outputBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),

            outputView.topAnchor.constraint(equalTo: outputBackground.topAnchor, constant: (padding / 2)),
            outputView.bottomAnchor.constraint(equalTo: outputBackground.bottomAnchor, constant: -(padding / 2)),
            outputView.leftAnchor.constraint(equalTo: outputBackground.leftAnchor, constant: (padding / 2)),
            outputView.rightAnchor.constraint(equalTo: outputBackground.rightAnchor, constant: -(padding / 2))
        ])
    }

    // MARK: - child view

    let inputBackground: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 1
        view.layer?.backgroundColor = NSColor.white.cgColor
        return view
    }()

    let outputBackground: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 1
        view.layer?.backgroundColor = NSColor(calibratedRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        return view
    }()

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
