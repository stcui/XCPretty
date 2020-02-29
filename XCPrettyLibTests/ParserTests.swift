//
//  ParserTests.swift
//  XCPrettyLibTests
//
//  Created by Steven Choi on 2020/3/1.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import XCTest
@testable import XCPretty

class ParserTests: XCTestCase {
    var formatter : MockFormatter! = nil
    var parser : XCPretty.Parser! = nil
    override func setUp() {
        formatter = MockFormatter()
        parser = XCPretty.Parser()
        parser.formatter = formatter
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNote() {
        let _ = parser.parse("note: Using new build system")
        XCTAssertEqual(formatter.calledMethods["format_note"],
                       ["Using new build system"])
    }
    
    func testAnalyze() {
        let _ = parser.parse(SAMPLE_ANALYZE)
        XCTAssertEqual(formatter.calledMethods["format_analyze"],
                       ["CCChip8DisplayView.m", "CocoaChip/CCChip8DisplayView.m"])
    }
    func testAnalyzeShallow() {
        let _ = parser.parse(SAMPLE_ANALYZE_SHALLOW)
        XCTAssertEqual(formatter.calledMethods["format_analyze"],
                       ["CCChip8DisplayView.m", "CocoaChip/CCChip8DisplayView.m"])
    }
    func testAnalyzeCppTarget() {
        let _ = parser.parse(SAMPLE_ANALYZE_CPP)
        XCTAssertEqual(formatter.calledMethods["format_analyze"],
                       ["CCChip8DisplayView.cpp", "CocoaChip/CCChip8DisplayView.cpp"])
    }
    func testBuildTarget() {
        let _ = parser.parse(SAMPLE_BUILD)
        XCTAssertEqual(formatter.calledMethods["format_build_target"],
                       ["The Spacer", "Pods", "Debug"])

    }
    func testAggregateTarget() {
        let _ = parser.parse(SAMPLE_AGGREGATE_TARGET)
        XCTAssertEqual(formatter.calledMethods["format_aggregate_target"],
                       ["Be Aggro", "AggregateExample", "Debug"])

    }
    func testAnalyzeTarget() {
        let _ = parser.parse(SAMPLE_ANALYZE_TARGET)
        XCTAssertEqual(formatter.calledMethods["format_analyze_target"],
                       ["The Spacer", "Pods", "Debug"])

    }
    
    func testCleanRemove() {
        let _ = parser.parse(SAMPLE_CLEAN_REMOVE)
        XCTAssertNotNil(formatter.calledMethods["format_clean_remove"])
    }

    func testCleanTarget() {
        let _ = parser.parse(SAMPLE_CLEAN)
        XCTAssertEqual(formatter.calledMethods["format_clean_target"], ["Pods-ObjectiveSugar", "Pods", "Debug"])
    }

    func testCleanTargetWithutDashInTargetName() {
        let _ = parser.parse(SAMPLE_ANOTHER_CLEAN)
        XCTAssertEqual(formatter.calledMethods["format_clean_target"], ["Pods", "Pods", "Debug"])
    }

    func testCheckDependencies() {
        let _ = parser.parse("Check dependencies")
        XCTAssertNotNil(formatter.calledMethods["format_check_dependencies"])
    }

    func testCodeSigning() {
        let _ = parser.parse(SAMPLE_CODESIGN)
        XCTAssertEqual(formatter.calledMethods["format_codesign"], ["build/Release/CocoaChip.app"])
    }

    func testCodeSigningAFramework() {
        let _ = parser.parse(SAMPLE_CODESIGN_FRAMEWORK)
        XCTAssertEqual(formatter.calledMethods["format_codesign"], ["build/Release/CocoaChipCore.framework"])
    }

    func testCompilerSpaceInPath() {
        let _ = parser.parse(SAMPLE_COMPILE_SPACE_IN_PATH)
        XCTAssertEqual(formatter.calledMethods["format_compile"], ["SASellableItem.m", "SACore/App/Models/Core\\ Data/human/SASellableItem.m"])
    }

    func testCompilerCommands() {
        let lastIndex = SAMPLE_ANOTHER_COMPILE.lastIndex(of: "\n")
        XCTAssertNotNil(lastIndex)
        let start: String.Index = SAMPLE_ANOTHER_COMPILE.index(after: lastIndex!)
        let compileStatemennt = String(SAMPLE_ANOTHER_COMPILE[start...])
        let _ = parser.parse(compileStatemennt)
        XCTAssertEqual(formatter.calledMethods["format_compile_command"], [compileStatemennt.strip(), "/Users/musalj/code/OSS/Kiwi/Classes/Core/KWNull.m"])
        
    }

    func testCompilingCategories() {
        let _ = parser.parse(SAMPLE_COMPILE)
        XCTAssertEqual(formatter.calledMethods["format_compile"], ["NSMutableArray+ObjectiveSugar.m", "/Users/musalj/code/OSS/ObjectiveSugar/Classes/NSMutableArray+ObjectiveSugar.m"])
    }

    func testCompilingClasses() {
        let _ = parser.parse(SAMPLE_ANOTHER_COMPILE)
        XCTAssertEqual(formatter.calledMethods["format_compile"], ["KWNull.m", "Classes/Core/KWNull.m"])
    }

    func testCompilingObjectiveCppClasses() {
        let _ = parser.parse(SAMPLE_ANOTHER_COMPILE.replacingOccurrences(of: ".m", with: ".mm"))
        XCTAssertEqual(formatter.calledMethods["format_compile"], ["KWNull.mm", "Classes/Core/KWNull.mm"])
    }

    func testCompilingSwiftSourceFiles() {
        let _ = parser.parse(SAMPLE_SWIFT_COMPILE)
        XCTAssertEqual(formatter.calledMethods["format_compile"], ["Resource.swift", "/Users/paul/foo/bar/siesta/Source/Resource.swift"])
    }

    func testCompilingCAndCppFiles() {
        [".c", ".cc", ".cpp", ".cxx"].forEach { (file_extension) in
            formatter.calledMethods.removeAll()
            let _ = parser.parse(SAMPLE_ANOTHER_COMPILE.replacingOccurrences(of:".m", with: file_extension))
            XCTAssertEqual(formatter.calledMethods["format_compile"], ["KWNull" + file_extension, "Classes/Core/KWNull" + file_extension])
        }
    }

    func testCompilingXIBs() {
        let _ = parser.parse(SAMPLE_COMPILE_XIB)
        XCTAssertEqual(formatter.calledMethods["format_compile_xib"], ["MainMenu.xib", "CocoaChip/en.lproj/MainMenu.xib"])
    }

    func testCompilingStoryboards() {
        let _ = parser.parse(SAMPLE_COMPILE_STORYBOARD)
        XCTAssertEqual(formatter.calledMethods["format_compile_storyboard"], ["Main.storyboard", "sample/Main.storyboard"])
    }

    func testCopyPlistFile() {
        let _ = parser.parse("CopyPlistFile /path/to/Some.plist /some other/File.plist")
        XCTAssertEqual(formatter.calledMethods["format_copy_plist_file"],
                       ["/path/to/Some.plist", "/some other/File.plist"])
    }

    func testCopyStringsFile() {
        let _ = parser.parse(SAMPLE_COPYSTRINGS)
        XCTAssertEqual(formatter.calledMethods["format_copy_strings_file"], ["InfoPlist.strings"])
    }
}
