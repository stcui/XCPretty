//
//  JUnitTests.swift
//  XCPrettyLibTests
//
//  Created by Steven Choi on 2020/3/8.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import XCTest
@testable import XCPretty

class JUnitTests: XCTestCase {
    var formatter : XCPretty.Reporter!
    var tempFile : String!
    override func setUp() {
        tempFile = NSTemporaryDirectory().appending(NSUUID().uuidString)
        formatter = XCPretty.JUnit(path: tempFile)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNameInRootNode() {
        let testName = "ReactiveCocoaTests.xctest"
        _ = formatter.format_test_run_started(testName)
        formatter.finish()
        XCTAssertNoThrow(
           try XMLDocument(contentsOf: URL(fileURLWithPath: tempFile), options: [])
        )
        let document = try! XMLDocument(contentsOf: URL(fileURLWithPath: tempFile), options: [])

        XCTAssertEqual(
            document.rootElement()?.attribute(forName: "name")?.stringValue,
            testName)
    }

}
