//
//  Matchers.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

// @regex Captured groups
// $1 note message
let NOTE_MATCHER = #"^note: (.*)$"#

// @regex Captured groups
// $1 file_path
// $2 file_name
let ANALYZE_MATCHER = #"^Analyze(?:Shallow)?\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s*"#

// @regex Captured groups
// $1 target
// $2 project
// $3 configuration
let BUILD_TARGET_MATCHER = #"^=== BUILD TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#

// @regex Captured groups
// $1 target
// $2 project
// $3 configuration
let AGGREGATE_TARGET_MATCHER = #"^=== BUILD AGGREGATE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#

// @regex Captured groups
// $1 target
// $2 project
// $3 configuration
let ANALYZE_TARGET_MATCHER = #"^=== ANALYZE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#

// @regex Nothing returned here for now
let CHECK_DEPENDENCIES_MATCHER = #"^Check dependencies"#

// @regex Captured groups
// $1 command path
// $2 arguments
let SHELL_COMMAND_MATCHER = #"^\s{4}(cd|setenv|(?:[\w\/:\\\s\-.]+?\/)?[\w\-]+)\s(.*)$"#

// @regex Nothing returned here for now
let CLEAN_REMOVE_MATCHER = #"^Clean.Remove"#

// @regex Captured groups
// $1 target
// $2 project
// $3 configuration
let CLEAN_TARGET_MATCHER = #"^=== CLEAN TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH CONFIGURATION\s(.*)\s==="#

// @regex Captured groups
// $1 = file
let CODESIGN_MATCHER = #"^CodeSign\s((?:\\ |[^ \n])*)"#

// @regex Captured groups
// $1 = file
let CODESIGN_FRAMEWORK_MATCHER = #"^CodeSign\s((?:\\ |[^ ])*.framework)\/Versions"#

// @regex Captured groups
// $1 file_path
// $2 file_name (e.g. KWNull.m)
let COMPILE_MATCHER = #"^Compile[\w]+\s.+?\s((?:\\.|[^ ])+\/((?:\\.|[^ ])+\.(?:m|mm|c|cc|cpp|cxx|swift)))\s.*"#

// @regex Captured groups
// $1 compiler_command
// $2 file_path
let COMPILE_COMMAND_MATCHER = #"^\s*(.*clang\s.*\s\-c\s(.*\.(?:m|mm|c|cc|cpp|cxx))\s.*\.o)$"#

// @regex Captured groups
// $1 file_path
// $2 file_name (e.g. MainMenu.xib)
let COMPILE_XIB_MATCHER = #"^CompileXIB\s(.*\/(.*\.xib))"#

// @regex Captured groups
// $1 file_path
// $2 file_name (e.g. Main.storyboard)
let COMPILE_STORYBOARD_MATCHER = #"^CompileStoryboard\s(.*\/([^\/].*\.storyboard))"#

// @regex Captured groups
// $1 source file
// $2 target file
let COPY_HEADER_MATCHER = #"^CpHeader\s(.*\.h)\s(.*\.h)"#

// @regex Captured groups
// $1 source file
// $2 target file
let COPY_PLIST_MATCHER = #"^CopyPlistFile\s(.*\.plist)\s(.*\.plist)"#

// $1 file
let COPY_STRINGS_MATCHER = #"^CopyStringsFile.*\/(.*.strings)"#

// @regex Captured groups
// $1 resource
let CPRESOURCE_MATCHER = #"^CpResource\s(.*)\s\/"#

// @regex Captured groups
let EXECUTED_MATCHER = #"^\s*Executed"#

// @regex Captured groups
// $1 = file
// $2 = test_suite
// $3 = test_let
// $4 = reason
let FAILING_TEST_MATCHER = #"^\s*(.+:\d+):\serror:\s[\+\-]\[(.*)\s(.*)\]\s:(?:\s'.*'\s\[FAILED\],)?\s(.*)"#

// @regex Captured groups
// $1 = file
// $2 = reason
let UI_FAILING_TEST_MATCHER = #"^\s{4}t = \s+\d+\.\d+s\s+Assertion Failure: (.*:\d+): (.*)$"#

// @regex Captured groups
let RESTARTING_TESTS_MATCHER = #"^Restarting after unexpected exit or crash in.+$"#

// @regex Captured groups
// $1 = dsym
let GENERATE_DSYM_MATCHER = #"^GenerateDSYMFile \/.*\/(.*\.dSYM)"#

// @regex Captured groups
// $1 = library
let LIBTOOL_MATCHER = #"^Libtool.*\/(.*\.a)"#

// @regex Captured groups
// $1 = target
// $2 = build_variants (normal, profile, debug)
// $3 = architecture
let LINKING_MATCHER = #"^Ld \/?.*\/(.*?) (.*) (.*)$"#

// @regex Captured groups
// $1 = suite
// $2 = test_let
// $3 = time
let TEST_CASE_PASSED_MATCHER = #"^\s*Test Case\s'-\[(.*)\s(.*)\]'\spassed\s\((\d*\.\d{3})\sseconds\)"#


// @regex Captured groups
// $1 = suite
// $2 = test_let
let TEST_CASE_STARTED_MATCHER = #"^Test Case '-\[(.*) (.*)\]' started.$"#

// @regex Captured groups
// $1 = suite
// $2 = test_let
let TEST_CASE_PENDING_MATCHER = #"^Test Case\s'-\[(.*)\s(.*)PENDING\]'\spassed"#

// @regex Captured groups
// $1 = suite
// $2 = test_let
// $3 = time
let TEST_CASE_MEASURED_MATCHER = #"^[^:]*:[^:]*:\sTest Case\s'-\[(.*)\s(.*)\]'\smeasured\s\[Time,\sseconds\]\saverage:\s(\d*\.\d{3}),"#

let PHASE_SUCCESS_MATCHER = #"^\*\*\s(.*)\sSUCCEEDED\s\*\*"#

// @regex Captured groups
// $1 = script_name
let PHASE_SCRIPT_EXECUTION_MATCHER = #"^PhaseScriptExecution\s((\\\ |\S)*)\s"#

// @regex Captured groups
// $1 = file
let PROCESS_PCH_MATCHER = #"^ProcessPCH\s.*\s(.*.pch)"#

// @regex Captured groups
// $1 file_path
let PROCESS_PCH_COMMAND_MATCHER = #"^\s*.*\/usr\/bin\/clang\s.*\s\-c\s(.*)\s\-o\s.*"#

// @regex Captured groups
// $1 = file
let PREPROCESS_MATCHER = #"^Preprocess\s(?:(?:\\ |[^ ])*)\s((?:\\ |[^ ])*)$"#

// @regex Captured groups
// $1 = file
let PBXCP_MATCHER = #"^PBXCp\s((?:\\ |[^ ])*)"#

// @regex Captured groups
// $1 = file
let PROCESS_INFO_PLIST_MATCHER = #"^ProcessInfoPlistFile\s.*\.plist\s(.*\/+(.*\.plist))"#

// @regex Captured groups
// $1 = suite
// $2 = time
let TESTS_RUN_COMPLETION_MATCHER = #"^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)"#

// @regex Captured groups
// $1 = suite
// $2 = time
let TEST_SUITE_STARTED_MATCHER = #"^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' started at(.*)"#

// @regex Captured groups
// $1 test suite name
let TEST_SUITE_START_MATCHER = #"^\s*Test Suite '(.*)' started at"#

// @regex Captured groups
// $1 file_name
let TIFFUTIL_MATCHER = #"^TiffUtil\s(.*)"#

// @regex Captured groups
// $1 file_path
// $2 file_name
let TOUCH_MATCHER = #"^Touch\s(.*\/(.+))"#

// @regex Captured groups
// $1 file_path
let WRITE_FILE_MATCHER = #"^write-file\s(.*)"#

// @regex Captured groups
let WRITE_AUXILIARY_FILES = #"^Write auxiliary files"#

// MARK:  Warnings

// $1 = file_path
// $2 = file_name
// $3 = reason
let COMPILE_WARNING_MATCHER = #"^(\/.+\/(.*):.*:.*):\swarning:\s(.*)$"#

// $1 = ld prefix
// $2 = warning message
let LD_WARNING_MATCHER = #"^(ld: )warning: (.*)"#

// @regex Captured groups
// $1 = whole warning
let GENERIC_WARNING_MATCHER = #"^warning:\s(.*)$"#

// @regex Captured groups
// $1 = whole warning
let WILL_NOT_BE_CODE_SIGNED_MATCHER = #"^(.* will not be code signed because .*)$"#


// Errors: String
// @regex Captured groups
// $1 = whole error
let CLANG_ERROR_MATCHER = #"^(clang: error:.*)$"#

// @regex Captured groups
// $1 = whole error
let CHECK_DEPENDENCIES_ERRORS_MATCHER = #"^(Code\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$"#

// @regex Captured groups
// $1 = whole error
let PROVISIONING_PROFILE_REQUIRED_MATCHER = #"^(.*requires a provisioning profile.*)$"#

// @regex Captured groups
// $1 = whole error
let NO_CERTIFICATE_MATCHER = #"^(No certificate matching.*)$"#

// @regex Captured groups
// $1 = file_path
// $2 = file_name
// $3 = reason
var COMPILE_ERROR_MATCHER = #"^(\/.+\/(.*):.*:.*):\s(?:fatal\s)?error:\s(.*)$"#

// @regex Captured groups
// $1 cursor (with whitespaces and tildes)
let CURSOR_MATCHER = #"^([\s~]*\^[\s~]*)$"#

// @regex Captured groups
// $1 = whole error.
// it varies a lot, not sure if it makes sense to catch everything separately
let FATAL_ERROR_MATCHER = #"^(fatal error:.*)$"#

// @regex Captured groups
// $1 = whole error.
// $2 = file path
let FILE_MISSING_ERROR_MATCHER = #"^<unknown>:0:\s(error:\s.*)\s'(\/.+\/.*\..*)'$"#

// @regex Captured groups
// $1 = whole error
let LD_ERROR_MATCHER = #"^(ld:.*)"#

// @regex Captured groups
// $1 file path
let LINKER_DUPLICATE_SYMBOLS_LOCATION_MATCHER = #"^\s+(\/.*\.o[\)]?)$"#

// @regex Captured groups
// $1 reason
let LINKER_DUPLICATE_SYMBOLS_MATCHER = #"^(duplicate symbol .*):$"#

// @regex Captured groups
// $1 symbol location
let LINKER_UNDEFINED_SYMBOL_LOCATION_MATCHER = #"^(.* in .*\.o)$"#

// @regex Captured groups
// $1 reason
let LINKER_UNDEFINED_SYMBOLS_MATCHER = #"^(Undefined symbols for architecture .*):$"#

// @regex Captured groups
// $1 reason
let PODS_ERROR_MATCHER = #"^(error:\s.*)"#

// @regex Captured groups
// $1 = reference
let SYMBOL_REFERENCED_FROM_MATCHER = #"\s+"(.*)", referenced from:$"#

// @regex Captured groups
// $1 = error reason
let MODULE_INCLUDES_ERROR_MATCHER = #"^\<module-includes\>:.*?:.*?:\s(?:fatal\s)?(error:\s.*)$"#


class MatchSwitch {
    let text : String
    var result : [String] = []
    init(_ text:String) {
        self.text = text
    }
    subscript(index: Int) -> String {
        return result[index]
    }

    func match(_ pattern: String) -> Bool {
        if let result = Regex(pattern).match(self.text) {
            self.result = result;
            return true
        } else {
            return false
        }
    }
    
    static func ~=(pattern: String, matchable: MatchSwitch) -> Bool {
        return matchable.match(pattern)
    }

}

