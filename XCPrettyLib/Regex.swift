//
//  Regex.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

struct Regex {
    let pattern: String
    let options: NSRegularExpression.Options
    private var matcher: NSRegularExpression? {
        return try? NSRegularExpression(pattern: self.pattern, options: options)
    }
    init(_ pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }
    func match(_ string: String, options: NSRegularExpression.MatchingOptions=[]) -> [String]? {
        guard let matcher = self.matcher else { return [] }
        let range = NSRange(location: 0, length: string.utf16.count)
        var results = [String]()
        matcher.enumerateMatches(in: string, options: options, range: range) { (resultOpt, flags, stop) in
            guard let result = resultOpt else { return }
            for i in 0..<result.numberOfRanges {
                let range = result.range(at: i)
                let start = string.index(string.startIndex, offsetBy: range.lowerBound)
                let end = string.index(string.startIndex, offsetBy: range.upperBound)
                let str = string[start ..< end]
                results.append(String(str))
            }
        }
        return results.count > 0 ? results : nil
    }
}

protocol RegularExpressionMatchable {
    func match(regex: Regex) -> Bool
}
extension String: RegularExpressionMatchable {
    func match(regex: Regex) -> Bool {
        return regex.match(self)?.count != 0
    }
}

func ~=<T: RegularExpressionMatchable>(pattern:Regex, matchable: T) -> Bool {
    return matchable.match(regex: pattern)
}
