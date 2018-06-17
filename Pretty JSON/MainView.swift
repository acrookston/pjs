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
        autoresizingMask = [.width, .height]
        translatesAutoresizingMaskIntoConstraints = true
        inputBackground.addSubview(inputView)
        inputView.textView.delegate = delegate
        addSubview(inputBackground)
        addSubview(outputView)
        setupConstraints()
    }

    private func setupConstraints() {
        inputBackground.translatesAutoresizingMaskIntoConstraints = false
        inputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            inputBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            inputBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            inputBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            inputBackground.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -(padding / 2)),

            inputView.topAnchor.constraint(equalTo: inputBackground.topAnchor),
            inputView.bottomAnchor.constraint(equalTo: inputBackground.bottomAnchor),
            inputView.leftAnchor.constraint(equalTo: inputBackground.leftAnchor),
            inputView.rightAnchor.constraint(equalTo: inputBackground.rightAnchor),

            outputView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            outputView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            outputView.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: (padding / 2)),
            outputView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
        ])
    }

    // MARK: - child view

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
        scrollText.backgroundColor = .lightGray
        return scrollText
    }()
}

final class PlainTextView: NSTextView {
    override func paste(_ sender: Any?) {
        pasteAsPlainText(sender)
    }
}
