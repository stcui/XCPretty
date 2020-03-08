//
//  ReporterTests.swift
//  XCPrettyLibTests
//
//  Created by Steven Choi on 2020/3/8.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import XCTest
@testable import XCPretty

class ReporterTests: XCTestCase {
    var reporter: XCPretty.Reporter!
    
    override func setUp() {
        reporter = Reporter(path: "example_file")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPassingTest() {
        _ = reporter.format_passing_test("RACCommandSpec", "_tupleByAddingObject__should_add_a_non_nil_object", "0.001")
        XCTAssertTrue(
            reporter.tests.contains("_tupleByAddingObject__should_add_a_non_nil_object PASSED")
        )
    }
    
    func testFailingTest() {
        _ = reporter.format_failing_test(
            "RACCommandSpec",
            "enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES",
            "expected: 1, got: 0", "path/to/file")
        XCTAssertTrue(
            reporter.tests
        .contains("enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES in path/to/file FAILED: expected: 1, got: 0")
        )
    }
    
    func testPendingTest() {
        _ = reporter.format_pending_test("RACCommandSpec", "_tupleByAddingObject__should_add_a_non_nil_object")
        XCTAssertTrue(reporter.tests.contains("_tupleByAddingObject__should_add_a_non_nil_object IS PENDING"))
    }
    
    func testWriteToDisk() {
        _ = reporter.format_passing_test("RACCommandSpec",
                                         "_tupleByAddingObject__should_add_a_non_nil_object",
                                         "0.001")
        reporter.writeReport()
        XCTAssertTrue(FileManager.default.fileExists(atPath: "example_file"))
    }
    
}
