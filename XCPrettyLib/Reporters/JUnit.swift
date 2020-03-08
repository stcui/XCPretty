//
//  JUnit.swift
//  XCPrettyLib
//
//  Created by Steven Choi on 2020/3/8.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

fileprivate let FILE_PATH = "build/reports/junit.xml"

class JUnit : Reporter {
    var directory : String
    var document : XMLDocument
    var totalFailes: Int = 0
    var totalTests: Int = 0
    var lastSuite: XMLElement? = nil
    override init(path: String = FILE_PATH) {
        directory = ProcessInfo.processInfo.environment["PWD"]!.trimmingCharacters(in: .whitespacesAndNewlines)
        document = XMLDocument(rootElement: XMLElement(name: "testsuites"))
        super.init(path: path)
    }
    
    override func handle(_ line: String) -> String? {
        return parser.parse(line)
    }
    
    override func format_test_run_started(_ name: String) -> String {
        document.rootElement()?.setAttributesWith(["name": name])
        return ""
    }
    override func format_passing_test(_ classname: String, _ test: String, _ time: String) -> String {
        let testNode = XMLElement(name: "testcase")
        suite(classname).addChild(testNode)
        testNode.setAttributesWith(["classname": classname,
                                    "name": test])
        testNode.addChild(XMLElement(name:"skipped"))
        testCount += 1
        return ""
    }

    override func format_pending_test(_ classname: String, _ test: String) -> String {
        let testNode = XMLElement(name: "testcase")
        suite(classname).addChild(testNode)
        testNode.setAttributesWith(["classname": classname,
                                    "name":test])
        testNode.addChild(XMLElement(name:"skipped"))
        testCount += 1
        return ""
    }
    
    override func format_failing_test(_ classname: String, _ test: String, _ reason: String, _ file_path: String) -> String {
        let testNode = XMLElement(name: "testcase")
        suite(classname).addChild(testNode)
        testNode.setAttributesWith(["classname": classname,
                                    "name":test])
        let failNode = XMLElement(name: "failure")
        testNode.addChild(failNode)
        failNode.setAttributesWith(["message": reason])
        let value = file_path.replacingOccurrences(of: directory+"/", with: "")
        failNode.setStringValue(value, resolvingEntities: false)
        testCount += 1
        failCount += 1
        return ""
    }
    
    override func writeReport() {
        let string = document.xmlString(options: .documentTidyXML)
        do {
            try string.write(toFile: self.filepath,
                             atomically: true,
                             encoding: .utf8)
        } catch {
            print("write report failed")
        }
        
    }

    private func suite(_ classname: String) -> XMLElement {
        if lastSuite != nil && lastSuite!.attribute(forName: "name")?.stringValue == classname {
            return lastSuite!
        }
        
        setTestCounters()
        lastSuite = XMLElement(name: "testsuite")
        document.rootElement()?.addChild(lastSuite!)
        return lastSuite!
    }
    
    private func setTestCounters() {
        if let lastSuite = lastSuite {
            lastSuite.setAttributesWith(["test": testCount.description,
                                         "failures": failCount.description])
        }
        totalFailes += failCount
        totalTests += testCount
        testCount = 0
        failCount = 0
    }
}
