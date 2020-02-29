//
//  Formatter.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

protocol FormatterProtocol : AnyObject {
    func format_note(_ message: String) -> String
    func format_analyze(_ file_name: String, _ file_path: String) -> String
    func format_build_target(_ target: String, _ project: String, _ configuration: String) -> String
    func format_aggregate_target(_ target: String, _ project: String, _ configuration: String) -> String
    func format_analyze_target(_ target: String, _ project: String, _ configuration: String) -> String
    func format_check_dependencies() -> String
    func format_clean(_ project: String, _ target: String, _ configuration: String) -> String
    func format_clean_target(_ target: String, _ project: String, _ configuration: String) -> String
    func format_clean_remove() -> String
    func format_compile(_ file_name: String, _ file_path: String) -> String
    func format_compile_command(_ compiler_command: String, _ file_path: String) -> String
    func format_compile_storyboard(_ file_name: String, _ file_path: String) -> String
    func format_compile_xib(_ file_name: String, _ file_path: String) -> String
    func format_copy_header_file(_ source: String, _ target: String) -> String
    func format_copy_plist_file(_ source: String, _ target: String) -> String
    func format_copy_strings_file(_ file_name: String) -> String
    func format_cpresource(_ file: String) -> String
    func format_generate_dsym(_ dsym: String) -> String
    func format_linking(_ file: String, _ build_variant: String, _ arch: String) -> String
    func format_libtool(_ library: String) -> String
    func format_passing_test(_ suite: String, _ test: String, _ time: String) -> String
    func format_pending_test(_ suite: String, _ test: String) -> String
    func format_measuring_test(_ suite: String, _ test: String, _ time: String) -> String
    func format_failing_test(_ suite: String, _ test: String, _ reason: String, _ file_path: String) -> String
    func format_process_pch(_ file: String) -> String
    func format_process_pch_command(_ file_path: String) -> String
    func format_phase_success(_ phase_name: String) -> String
    func format_phase_script_execution(_ script_name: String) -> String
    func format_process_info_plist(_ file_name: String, _ file_path: String) -> String
    func format_codesign(_ file: String) -> String
    func format_preprocess(_ file: String) -> String
    func format_pbxcp(_ file: String) -> String
    func format_shell_command(_ command: String, _ arguments: String) -> String
    func format_test_run_started(_ name: String) -> String
    func format_test_run_finished(_ name: String, _ time: String) -> String
    func format_test_suite_started(_ name: String) -> String
    func format_test_summary(_ message: String, _ failures_per_suite: [String:[Parser.Issue]]) -> String
    func format_touch(_ file_path: String, _ file_name: String) -> String
    func format_tiffutil(_ file: String) -> String
    func format_write_file(_ file: String) -> String
    func format_write_auxiliary_files()->String
    func format_other(_ text: String) -> String
    
    // COMPILER / LINKER ERRORS AND WARNINGS
    func format_compile_error(_ file_name: String,
                              _ file_path: String,
                              _ reason: String,
                              _ line: String,
                              _ cursor: String) -> String
    func format_error(_ message: String) -> String
    func format_file_missing_error(_ error: String, _ file_path: String) -> String
    func format_ld_warning(_ message: String) -> String
    func format_undefined_symbols(_ message: String,
                                   _ symbol: String,
                                   _ reference: String) -> String
    func format_duplicate_symbols(_ message: String,
                                  _ file_paths: [String]) -> String
    func format_warning(_ message: String) -> String
    
    // TODO: see how we can unify format_error and _ format_compile_error: String
    //       the same for warnings
    func format_compile_warning(_ file_name: String,
                                _ file_path: String,
                                _ reason: String,
                                _ line: String,
                                _ cursor: String) -> String
    func format_will_not_be_code_signed(_ message:String) -> String
}


public class Formatter : FormatterProtocol {
    static let NOTE = "🗒 "
    static let ASCII_NOTE = "[#] "
    static let ERROR = "❌ "
    static let ASCII_ERROR = "[x]"
    static let WARNING = "⚠️ "
    static let ASCII_WARNING = "[!]"
    let ansi = ANSI()
    var useUnicode = true
    var parser : Parser
    var error_symbol: String {
        self.useUnicode ? Formatter.ERROR : Formatter.ASCII_ERROR
    }
    var warning_symbol : String {
        self.useUnicode ? Formatter.WARNING : Formatter.ASCII_WARNING
    }
    
    func format_note(_ message: String) -> String {
        return "\(self.useUnicode ? Formatter.NOTE : Formatter.ASCII_NOTE) \(message)"
    }

    func format_error(_ message: String) -> String {
        return "\n\(red(error_symbol + " " + message))\n\n"
    }
    func format_compile_error(file: String, file_path: String, reason: String, line: String, cursor: String) -> String {
        return """
        \n\(red(error_symbol + " "))\(file_path): \(red(reason))\n\n
        \(line)\n\(cyan(cursor))\n\n
        """
    }
    func format_file_missing_error(_ reason: String, _ file_path: String) -> String  {
      return "\n\(red(error_symbol + " " + reason)) \(file_path)\n\n"
    }

    func format_compile_warning(_ file: String, _ file_path: String, _ reason: String, line: String, cursor: String) -> String {
        """
        \n\(yellow(warning_symbol + " "))\(file_path): \(yellow(reason))\n\n\(line)\n
        \(cyan(cursor))\n\n
        """
    }

    func format_ld_warning(_ reason: String) -> String {
        "\(yellow(warning_symbol + " " + reason))"
    }

    func format_undefined_symbols(_ message: String,
                                  _ symbol: String,
                                  _ reference: String) -> String {
        """
        \n\(red(error_symbol + " " + message))\n
        "> Symbol: \(symbol)\n
        "> Referenced from: \(reference)\n\n
        """
    }

    func format_duplicate_symbols(_ message: String,
                                  _ file_paths: [String]) -> String {
        let formattedFilePath: String = file_paths.map {
            $0.split(separator:"/").last ?? $0[$0.startIndex..<$0.endIndex]
        }.joined(separator: "\n> ")
        
        return """
        \n\(red(error_symbol + " " + message))\n
        > \(formattedFilePath)\n
        """
    }
    
    func format_will_not_be_code_signed(_ message: String) -> String {
        "\(yellow(warning_symbol + " " + message))"
    }
    
    func format_other(_:String)-> String  {
      ""
    }
    public init() {
        self.parser = Parser()
        self.parser.formatter = self
    }
    
    public func prettyFormat(_ text: String) -> String? {
        return parser.parse(text)
    }
    func format_analyze(_ file_name: String, _ file_path: String) -> String {
        return ""
    }
    func format_build_target(_ target: String, _ project: String, _ configuration: String) -> String { return "" }
    func format_aggregate_target(_ target: String, _ project: String, _ configuration: String) -> String { "" }
    func format_analyze_target(_ target: String, _ project: String, _ configuration: String) -> String { "" }
    func format_check_dependencies()->String { "" }
    func format_clean(_ project: String, _ target: String, _ configuration: String) -> String { "" }
    func format_clean_target(_ target: String, _ project: String, _ configuration: String) -> String { "" }
    func format_clean_remove()->String { "" }
    func format_compile(_ file_name: String, _ file_path: String) -> String { "" }
    func format_compile_command(_ compiler_command: String, _ file_path: String) -> String { "" }
    func format_compile_storyboard(_ file_name: String, _ file_path: String) -> String { "" }
    func format_compile_xib(_ file_name: String, _ file_path: String) -> String { "" }
    func format_copy_header_file(_ source: String, _ target: String) -> String { "" }
    func format_copy_plist_file(_ source: String, _ target: String) -> String { "" }
    func format_copy_strings_file(_ file_name: String) -> String { "" }
    func format_cpresource(_ file: String) -> String { "" }
    func format_generate_dsym(_ dsym: String) -> String { "" }
    func format_linking(_ file: String, _ build_variant: String, _ arch: String) -> String { "" }
    func format_libtool(_ library: String) -> String { "" }
    func format_passing_test(_ suite: String, _ test: String, _ time: String) -> String { "" }
    func format_pending_test(_ suite: String, _ test: String) -> String { "" }
    func format_measuring_test(_ suite: String, _ test: String, _ time: String) -> String { "" }
    func format_failing_test(_ suite: String, _ test: String, _ reason: String, _ file_path: String) -> String { "" }
    func format_process_pch(_ file: String) -> String { "" }
    func format_process_pch_command(_ file_path: String) -> String { "" }
    func format_phase_success(_ phase_name: String) -> String { "" }
    func format_phase_script_execution(_ script_name: String) -> String { "" }
    func format_process_info_plist(_ file_name: String, _ file_path: String) -> String { "" }
    func format_codesign(_ file: String) -> String { "" }
    func format_preprocess(_ file: String) -> String { "" }
    func format_pbxcp(_ file: String) -> String { "" }
    func format_shell_command(_ command: String, _ arguments: String) -> String { "" }
    func format_test_run_started(_ name: String) -> String { "" }
    func format_test_run_finished(_ name: String, _ time: String) -> String { "" }
    func format_test_suite_started(_ name: String) -> String { "" }
    func format_test_summary(_ message: String, _ failures_per_suite: [String: [Parser.Issue]]) -> String { "" }
    func format_touch(_ file_path: String, _ file_name: String) -> String { "" }
    func format_tiffutil(_ file: String) -> String { "" }
    func format_write_file(_ file: String) -> String { "" }
    func format_write_auxiliary_files() -> String {""}
//    func format_other(_ text: String) -> String { "" }
    
    // COMPILER / LINKER ERRORS AND WARNINGS
    func format_compile_error(_ file_name: String,
                              _ file_path: String,
                              _ reason: String,
                              _ line: String,
                              _ cursor: String) -> String { "" }
//    func format_error(_ message: String) -> String { "" }
//    func format_file_missing_error(_ error: String, _ file_path: String) -> String { "" }
//    func format_ld_warning(_ message: String) -> String { "" }
//    func format_undefined_symbols(_ message: String, _ symbol: String, _ reference: String) -> String { "" }
//    func format_duplicate_symbols(_ message: String, _ file_paths: [String]) -> String { "" }
    func format_warning(_ message: String) -> String { message; }
    // TODO: see how we can unify format_error and _ format_compile_error: String
    //       the same for warnings
    func format_compile_warning(_ file_name: String,
                                _ file_path: String,
                                _ reason: String,
                                _ line: String,
                                _ cursor: String) -> String { "" }
}

extension Formatter {
    var red:(String)-> String { get{ ansi.red } }
    var cyan:(String)-> String { get{ ansi.cyan } }
    var yellow:(String)-> String { get{ ansi.yellow } }
    var green:(String)-> String { get {ansi.green }}
    var white:(String)-> String { get{ ansi.white } }
//    var red:(String)-> String { get{ ansi.red } }

}
