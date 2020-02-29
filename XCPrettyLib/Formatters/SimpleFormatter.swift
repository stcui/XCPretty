//
//  SimpleFormatter.swift
//  XCPrettyLib
//
//  Created by Steven Choi on 2020/3/1.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

fileprivate let PASS = "✓"
fileprivate let FAIL = "✗"
fileprivate let PENDING = "⧖"
fileprivate let COMPLETION = "▸"
fileprivate let MEASURE = "◷"

fileprivate let ASCII_PASS = "."
fileprivate let ASCII_FAIL = "x"
fileprivate let ASCII_PENDING = "P"
fileprivate let ASCII_COMPLETION = ">"
fileprivate let ASCII_MEASURE = "T"
fileprivate let INDENT = "    "


class SimpleFormatter : Formatter {
    
    enum Status {
        case pass
        case fail
        case pending
        case error
        case completion
        case measure
    }
        
    override func format_analyze(_ file_name:String, _ file_path: String) -> String {
        print("ana")
        return format("Analyzing", file_name)
    }
    
    override func format_build_target(_ target:String, _ project:String, _ configuration:String) -> String {
        print("build")
        return format("Building", "#{project}/#{target} [#{configuration}]")
    }
    
    override func format_aggregate_target(_ target:String, _ project:String, _ configuration:String) -> String {
        return format("Aggregate", "#{project}/#{target} [#{configuration}]")
    }
    
    override func format_analyze_target(_ target:String, _ project:String, _ configuration:String) -> String {
        return format("Analyzing", "#{project}/#{target} [#{configuration}]")
    }
    
    override func format_clean_target(_ target:String, _ project:String, _ configuration:String) -> String {
        return format("Cleaning", "#{project}/#{target} [#{configuration}]")
    }
    
    override func format_compile(_ file_name:String, _ file_path:String) -> String {
        return format("Compiling", file_name)
    }
    
    override func format_compile_xib(_ file_name:String, _ file_path:String) -> String {
        return format("Compiling", file_name)
    }
    
    override func format_compile_storyboard(_ file_name:String, _ file_path:String) -> String {
        return format("Compiling", file_name)
    }
    
    override func format_copy_header_file(_ source:String, _ target:String) -> String {
        return format("Copying", basename(source))
    }
    
    override func format_copy_plist_file(_ source:String, _ target:String) -> String {
        return format("Copying", basename(source))
    }
    
    override func format_copy_strings_file(_ file: String) -> String {
        return format("Copying", file)
    }
    
    override func format_cpresource(_ resource:String) -> String {
        return format("Copying", resource)
    }
    
    override func format_generate_dsym(_ dsym: String) -> String {
        return format("Generating '#{dsym}'")
    }
    
    override func format_libtool(_ library:String) -> String {
        return format("Building library", library)
    }
    
    override func format_linking(_ target:String,_ build_variants:String, _ arch:String) -> String {
        return format("Linking", target)
    }
    
    override func format_failing_test(_ suite:String, _ test_case:String, _ reason:String, _ file:String) -> String {
        return INDENT + format_test("#{test_case}, #{reason}", .fail)
    }
    
    override func format_passing_test(_ suite:String, _ test_case:String, _ time:String) -> String {
        return INDENT + format_test("#{test_case} (#{colored_time(time)} seconds)",
                                    .pass)
    }
    
    override func format_pending_test(_ suite:String, _ test_case:String) -> String {
        return INDENT + format_test("#{test_case} [PENDING]", .pending)
    }
    
    override func format_measuring_test(_ suite:String, _ test_case:String, _ time:String) -> String {
        return INDENT + format_test(
            "#{test_case} measured (#{colored_time(time)} seconds)", .measure
        )
    }
    
    override func format_phase_success(_ phase_name: String) -> String {
        return format(phase_name.capitalized, "Succeeded")
    }
    
    override func format_phase_script_execution(_ script_name:String) -> String {
        return format("Running script", "'\(script_name)'")
    }
    
    override func format_process_info_plist(_ file_name:String, _ file_path:String) -> String {
        return format("Processing", file_name)
    }
    
    override func format_process_pch(_ file:String) -> String {
        return format("Precompiling", file)
    }
    
    override func format_codesign(_ file:String) -> String {
        return format("Signing", file)
    }
    
    override func format_preprocess(_ file:String) -> String {
        return format("Preprocessing", file)
    }
    
    override func format_pbxcp(_ file:String) -> String {
        return format("Copying", file)
    }
    
    override func format_test_run_started(_ name:String) -> String {
        return heading("Test Suite", name, "started")
    }
    
    override func format_test_suite_started(_ name:String) -> String {
        return heading("", name, "")
    }
    
    override func format_touch(_ file_path:String, _ file_name:String) -> String {
        return format("Touching", file_name)
    }
    
    override func format_tiffutil(_ file_name: String) -> String {
        return format("Validating", file_name)
    }
    
    override func format_warning(_ message:String) -> String {
        return INDENT + yellow(message)
    }
    
    override func format_check_dependencies() -> String {
        return format("Check Dependencies")
    }
    
    // MARK: private
    private func basename(_ path:String) -> String {
        return (path as NSString).lastPathComponent
    }
    private func heading(_ prefix:String,_ text:String,_ description:String) -> String {
        return [prefix, white(text), description].joined(separator:" ").strip()
    }
    
    private func format(_ command: String,
                        _ argument_text:String = "",
                        _ success:Bool = true) -> String {
        let symbol = status_symbol(success ? .completion : .fail)
        return [symbol, white(command), argument_text].joined(separator: " ").strip()
    }
    
    private func format_test(_ test_case:String, _ status: Status) -> String {
        [status_symbol(status), test_case].joined(separator:" ").strip()
    }
    
    private func status_symbol(_ status: Status) -> String {
        switch status {
        case .pass:
            return green(useUnicode ? PASS : ASCII_PASS)
        case .fail:
            return red(useUnicode ? FAIL : ASCII_FAIL)
        case .pending:
            return yellow(useUnicode ? PENDING : ASCII_PENDING)
        case .error:
            return red(useUnicode ? Formatter.ERROR : Formatter.ASCII_ERROR)
        case .completion:
            return yellow(useUnicode ? COMPLETION : ASCII_COMPLETION)
        case .measure:
            return yellow(useUnicode ? MEASURE : ASCII_MEASURE)
        }
    }
    
    private func colored_time(_ time: String) -> String {
        guard let number: Float = Float(time) else {
            return red(time)
        }
        switch number {
        case 0...0.025:
            return time
        case 0.026...0.100:
            return yellow(time)
        default:
            return red(time)
        }
    }
}
