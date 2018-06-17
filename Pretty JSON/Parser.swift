//
//  Parser.swift
//  Pretty JSON
//
//  Created by Andrew Crookston on 10/4/17.
//  Copyright © 2017 Andrew Crookston. All rights reserved.
//

import Foundation
//import Jay

enum ParserErrors: Error {
    case parsingError(Error)
    case emptyString
    case stringEncoding
}

enum ParserResult<T> {
    case success(T)
    case error(ParserErrors)
}

final class Parser {
    func parse(_ text: String, _ callback: @escaping (ParserResult<String>) -> ()) {
        if text.isEmpty {
            callback(.error(.emptyString))
            return
        }

        do {
            if let data = text.data(using: text.fastestEncoding) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let string = String(data: jsonData, encoding: .utf8) {
                    callback(.success(string))
                } else {
                    callback(.error(.stringEncoding))
                }
            }
        } catch {
            print("Parsing error: \(error)")
            callback(.error(.parsingError(error)))
        }
    }
}
