//
//  MainViewController.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import AppKit

protocol ParserInputDelegate: class {
    func parseText(input: String, mode: ParserMode)
    func copyOutput()
}

final class MainViewController: NSViewController {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(sender: Any?) { super.init(nibName: nil, bundle: nil) }

    // MARK: - View loading

    private lazy var mainView = MainView(delegate: self)

    override func loadView() {
        // Prevents loading from nib
        view = mainView
    }

    override func viewDidAppear() {
        let size: CGFloat = 800
        let screen = NSScreen.main?.frame.size ?? .zero
        let origin = CGPoint(x: (screen.width - size) / 2, y: (screen.height - size) / 2)
        let frameSize = CGSize(width: size, height: size)
        self.view.window?.setFrame(NSRect(origin: origin, size: frameSize), display: true)

        mainView.inputView.becomeFirstResponder()
    }

    // MARK: - NotificationCenter

    @objc func textPaste() {
        if let text = NSPasteboard.general.string(forType: .string) {
            mainView.inputView.textView.string = text
            parseInputText()
        }
    }

    // MARK: - actions

    private func parseInputText() {
        parseText(input: mainView.inputView.textView.string, mode: mainView.parsingMode)
    }
}

extension MainViewController: ParserInputDelegate {
    func parseText(input: String, mode: ParserMode) {
        Parser().parse(input, mode: mode) { [weak self] result in
            switch result {
            case .success(let parsedString):
                self?.mainView.outputView.textView.string = parsedString
            case .error(let error):
                switch error {
                case ParserErrors.emptyString:
                    self?.mainView.outputView.textView.string = ""
                default:
                    self?.mainView.outputView.textView.string = "PARSING ERROR:\n\n\(error.localizedDescription)"
                }
            }
        }
    }

    func copyOutput() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(mainView.outputView.textView.string, forType: .string)
    }
}
