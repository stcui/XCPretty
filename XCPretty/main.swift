//
//  main.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation
import XCPretty
let printer = XCPretty.Printer()
while let line = readLine(strippingNewline: true) {
    printer.prettyPrint(line)
}
