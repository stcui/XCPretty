//
//  MockFormatter.swift
//  XCPrettyLibTests
//
//  Created by Steven Choi on 2020/3/1.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation
@testable import XCPretty

class MockFormatter : XCPretty.Formatter {
    var calledMethods = [String:[String]]()
    private func log(_ method: String = #function, _ args: String...) -> String {
        let index: String.Index = method.firstIndex(of: "(")!
        let methodName = method[method.startIndex ..< index]
        calledMethods[String(methodName)] = args
        return ""
    }
    override func format_note(_ message: String) -> String {
        log(#function, message)
    }
    override func format_will_not_be_code_signed(_ message: String) -> String {
        log(#function, message)
    }
    
    override func format_analyze(_ file_name: String, _ file_path: String) -> String {
        log(#function, file_name, file_path)
    }
    override func format_build_target(_ target: String, _ project: String, _ configuration: String) -> String { log(#function, target, project, configuration) }
    override func format_aggregate_target(_ target: String, _ project: String, _ configuration: String) -> String {
        log(#function, target, project, configuration)
    }
    override func format_analyze_target(_ target: String, _ project: String, _ configuration: String) -> String {
        log(#function, target, project, configuration)
    }
    override func format_check_dependencies()->String { log(#function) }
    override func format_clean(_ project: String, _ target: String, _ configuration: String) -> String { log(#function, target, project, configuration) }
    override func format_clean_target(_ target: String, _ project: String, _ configuration: String) -> String { log(#function, target, project, configuration) }
    // TODO:
    override func format_clean_remove()->String { log(#function) }
    override func format_compile(_ file_name: String, _ file_path: String) -> String { log(#function, file_name, file_path) }
    override func format_compile_command(_ compiler_command: String, _ file_path: String) -> String { log(#function, compiler_command, file_path) }
    override func format_compile_storyboard(_ file_name: String, _ file_path: String) -> String { log(#function, file_name, file_path) }
    override func format_compile_xib(_ file_name: String, _ file_path: String) -> String { log(#function, file_name, file_path) }
    override func format_copy_header_file(_ source: String, _ target: String) -> String { log(#function, source, target) }
    override func format_copy_plist_file(_ source: String, _ target: String) -> String { log(#function, source, target) }
    override func format_copy_strings_file(_ file_name: String) -> String { log(#function, file_name) }
    override func format_cpresource(_ file: String) -> String { log(#function, file) }
    override func format_generate_dsym(_ dsym: String) -> String { log(#function, dsym) }
    override func format_linking(_ file: String, _ build_variant: String, _ arch: String) -> String { log(#function, file, build_variant, arch) }
    override func format_libtool(_ library: String) -> String { log(#function, library) }
    override func format_passing_test(_ suite: String, _ test: String, _ time: String) -> String { log(#function, suite, test, time) }
    override func format_pending_test(_ suite: String, _ test: String) -> String { log(#function, suite, test) }
    override func format_measuring_test(_ suite: String, _ test: String, _ time: String) -> String { log(#function, suite, test, time) }
    override func format_failing_test(_ suite: String, _ test: String, _ reason: String, _ file_path: String) -> String { log(#function, suite, test, reason) }
    override func format_process_pch(_ file: String) -> String { log(#function, file) }
    override func format_process_pch_command(_ file_path: String) -> String { log(#function, file_path) }
    override func format_phase_success(_ phase_name: String) -> String { log(#function, phase_name) }
    override func format_phase_script_execution(_ script_name: String) -> String { log(#function, script_name) }
    override func format_process_info_plist(_ file_name: String, _ file_path: String) -> String { log(#function, file_name, file_path) }
    override func format_codesign(_ file: String) -> String { log(#function, file) }
    override func format_preprocess(_ file: String) -> String { log(#function, file) }
    override func format_pbxcp(_ file: String) -> String { log(#function, file) }
    override func format_shell_command(_ command: String, _ arguments: String) -> String { log(#function, command, arguments) }
    override func format_test_run_started(_ name: String) -> String { log(#function, name) }
    override func format_test_run_finished(_ name: String, _ time: String) -> String { log(#function, name, time) }
    override func format_test_suite_started(_ name: String) -> String { log(#function, name) }
    override func format_test_summary(_ message: String, _ failures_per_suite: [String:[XCPretty.Parser.Issue]]) -> String { log(#function, message, failures_per_suite.description) }
    override func format_touch(_ file_path: String, _ file_name: String) -> String { log(#function, file_name, file_path) }
    override func format_tiffutil(_ file: String) -> String { log(#function, file) }
    override func format_write_file(_ file: String) -> String { log(#function, file) }
    override func format_write_auxiliary_files() -> String {log(#function)}
    override func format_other(_ text: String) -> String { log(#function, text) }
    
    // COMPILER / LINKER ERRORS AND WARNINGS
    override func format_compile_error(_ file_name: String,
                                       _ file_path: String,
                                       _ reason: String,
                                       _ line: String,
                                       _ cursor: String) -> String {
        log(#function, file_name, file_path, reason, line, cursor)
        
    }
    override func format_error(_ message: String) -> String { log(#function, message) }
    override func format_file_missing_error(_ error: String, _ file_path: String) -> String { log(#function, error, file_path) }
    override func format_ld_warning(_ message: String) -> String { log(#function,message) }
    override func format_undefined_symbols(_ message: String, _ symbol: String, _ reference: String) -> String { log(#function, message, symbol, reference) }
    override func format_duplicate_symbols(_ message: String, _ file_paths: [String]) -> String {
        log(#function, message, file_paths.description)
    }
    override func format_warning(_ message: String) -> String { log(#function, message) }
    // TODO: see how we can unify format_error and _ format_compile_error: String
    //       the same for warnings
    override func format_compile_warning(_ file_name: String,
                                         _ file_path: String,
                                         _ reason: String,
                                         _ line: String,
                                         _ cursor: String) -> String {
        log(#function, file_name, file_path, reason, line, cursor)
    }
}
