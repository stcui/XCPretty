//
//  Reporter.swift
//  XCPrettyLib
//
//  Created by Steven Choi on 2020/3/2.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation
fileprivate let FILE_PATH = "build/reports/tests.txt"

class Reporter : Formatter {
    var tests:[String] = []
    let filepath : String
    var testCount = 0
    var failCount = 0

    init(path: String = FILE_PATH) {
        filepath = path
        super.init()
    }

    func handle(_ line: String) -> String? {
        parser.parse(line)
    }
    
    func finish() {
        let dirname = (self.filepath as NSString).deletingLastPathComponent
        try? FileManager.default.createDirectory(atPath: dirname,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        writeReport()
    }

    override func format_failing_test(_ suite: String,
                           _ test: String,
                           _ reason: String,
                           _ file_path: String) -> String {
        testCount += 1
        failCount += 1
        tests.append("\(test) in \(file_path) FAILED: \(reason)")
        return ""
    }
    
    override func format_passing_test(_ suite: String, _ test: String, _ time: String) -> String {
        testCount += 1
        tests.append("\(test) PASSED")
        return ""
    }
    
    override func format_pending_test(_ suite: String, _ test: String) -> String {
        testCount += 1
        tests.append("\(test) IS PENDING")
        return ""
    }
    
    func writeReport() {
        var result = tests.joined(separator: "\n")
        result += "\nFINISHED RUNNING \(testCount) TESTS WITH \(failCount) FAILURES"
        do {
            try result.write(toFile: filepath, atomically: true, encoding: .utf8)
        } catch {
            print("failed")
        }
    }
}
