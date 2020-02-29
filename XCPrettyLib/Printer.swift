//
//  Printer.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

public class Printer {
    private let formatter : Formatter
    public init() {
        formatter = SimpleFormatter()
    }
    
    public func prettyPrint(_ line : String) {
        if let formatted = formatter.prettyFormat(line) {
            if formatted.lengthOfBytes(using: .utf8) > 0 {
                print(formatted)
                fflush(stdout)
            }
        } else {
            print(line)
        }
    }
}


