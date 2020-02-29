//
//  ANSI.swift
//  XCPrettyLibTests
//
//  Created by Steven Choi on 2020/3/1.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import XCTest
@testable import XCPretty

let text = "This is the PARTY"

class ANSITests: XCTestCase {
    var ansi : XCPretty.ANSI! = nil
    
    override func setUp() {
        ansi = XCPretty.ANSI()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testColors() {
        XCTAssertEqual(self.ansi.red(text), "\u{1B}[31m\(text)\u{1B}[0m")
        XCTAssertEqual(self.ansi.white(text), "\u{1B}[39;1m\(text)\u{1B}[0m")
        XCTAssertEqual(self.ansi.green(text), "\u{1B}[32;1m\(text)\u{1B}[0m")
        XCTAssertEqual(self.ansi.cyan(text), "\u{1B}[36m\(text)\u{1B}[0m")
    }
    func testCustomParse() {
        XCTAssertEqual(self.ansi.parse(text:text, color:.yellow, effect:.underline), "\u{1B}[33;4m\(text)\u{1B}[0m")
    }
    func testStrip() {
        XCTAssertEqual(self.ansi.strip("\u{1B}[33;4m\(text)\u{1B}[0m"), text)
    }
    func testEffectsQuery() {
        XCTAssertEqual(self.ansi.appliedEffects("\u{1B}[33;1m\(text)\u{1B}[0m"), [XCPretty.ANSI.Color.yellow.rawValue, XCPretty.ANSI.Effect.bold.rawValue])
    }
}
