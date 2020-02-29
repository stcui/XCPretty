//
//  Parser.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

extension String {
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
class Parser {
    var testsDone = false
    var formattingError = false
    var formattingWarning = false

    var formattedSummary = false
    
    var failures = [String:String]()
    var testSuite: String = ""
    var testCase: String = ""
    struct Issue {
        var reason: String? = nil
        var filePath: String? = nil
        var fileName: String? = nil
        var cursor: String? = nil
        var line: String? = nil
        var message: String? = nil
        var symbol: String? = nil
        var reference: String? = nil
        var files = [String]()
        var testCase: String? = nil
    }
    var currentIssue = Issue()
    var currentLinkerFailure = Issue()
    var formattingLinkerFailure = false
    
    var failuresPerSuite = [String: [Issue]]()
    
    weak var formatter : FormatterProtocol! = nil
    
    public func parse(_ text: String) -> String? {
        updateTestState(text)
        updateErrorState(text)
        updateLinkerFailureState(text)
        
        if shouldFormatError {
            return formatCompileError()
        }
        if shouldFormatWarning {
            return formatCompileWarning()
        }
        if shouldFormatUndefinedSymbols {
            return formatUndefinedSymbols()
        }
        if (shouldFormatDuplicateSymbols) {
            return formatUndefinedSymbols()
        }
        guard let formatter = self.formatter else {
            return text
        }

        var ret = ""
        let r = MatchSwitch(text)
        switch (r) {
        case NOTE_MATCHER:
            ret = formatter.format_note(r[1])
        case ANALYZE_MATCHER:
            ret = formatter.format_analyze(r[2], r[1])
        case BUILD_TARGET_MATCHER:
            ret = formatter.format_build_target(r[1], r[2], r[3])
        case AGGREGATE_TARGET_MATCHER:
            ret = formatter.format_aggregate_target(r[1], r[2], r[3])
        case ANALYZE_TARGET_MATCHER:
            ret = formatter.format_analyze_target(r[1], r[2], r[3])
        case CLEAN_REMOVE_MATCHER:
            ret = formatter.format_clean_remove()
        case CLEAN_TARGET_MATCHER:
            ret = formatter.format_clean_target(r[1], r[2], r[3])
        case COPY_STRINGS_MATCHER:
            ret = formatter.format_copy_strings_file(r[1])
        case CHECK_DEPENDENCIES_MATCHER:
            ret = formatter.format_check_dependencies()
        case CLANG_ERROR_MATCHER:
            ret = formatter.format_error(r[1])
        case CODESIGN_FRAMEWORK_MATCHER:
            ret = formatter.format_codesign(r[1])
        case CODESIGN_MATCHER:
            ret = formatter.format_codesign(r[1])
        case CHECK_DEPENDENCIES_ERRORS_MATCHER:
            ret = formatter.format_error(r[1])
        case PROVISIONING_PROFILE_REQUIRED_MATCHER:
            ret = formatter.format_error(r[1])
        case NO_CERTIFICATE_MATCHER:
            ret = formatter.format_error(r[1])
        case COMPILE_MATCHER:
            ret = formatter.format_compile(r[2], r[1])
        case COMPILE_COMMAND_MATCHER:
            ret = formatter.format_compile_command(r[1], r[2])
        case COMPILE_XIB_MATCHER:
            ret = formatter.format_compile_xib(r[2], r[1])
        case COMPILE_STORYBOARD_MATCHER:
            ret = formatter.format_compile_storyboard(r[2], r[1])
        case COPY_HEADER_MATCHER:
            ret = formatter.format_copy_header_file(r[1], r[2])
        case COPY_PLIST_MATCHER:
            ret = formatter.format_copy_plist_file(r[1], r[2])
        case CPRESOURCE_MATCHER:
            ret = formatter.format_cpresource(r[1])
        case EXECUTED_MATCHER:
            ret = formatSummaryIfNeeded(text)
        case RESTARTING_TESTS_MATCHER:
            ret = formatter.format_failing_test(testSuite, testCase, "Test crashed", "n/a")
        case UI_FAILING_TEST_MATCHER:
            ret = formatter.format_failing_test(testSuite, testCase, r[2], r[1])
        case FAILING_TEST_MATCHER:
            ret = formatter.format_failing_test(r[2], r[3], r[4], r[1])
        case FATAL_ERROR_MATCHER:
            ret = formatter.format_error(r[1])
        case FILE_MISSING_ERROR_MATCHER:
            ret = formatter.format_file_missing_error(r[1], r[2])
        case GENERATE_DSYM_MATCHER:
            ret = formatter.format_generate_dsym(r[1])
        case LD_WARNING_MATCHER:
            ret = formatter.format_ld_warning(r[1] + r[2])
        case LD_ERROR_MATCHER:
            ret = formatter.format_error(r[1])
        case LIBTOOL_MATCHER:
            ret = formatter.format_libtool(r[1])
        case LINKING_MATCHER:
            ret = formatter.format_linking(r[1], r[2], r[3])
        case MODULE_INCLUDES_ERROR_MATCHER:
            ret = formatter.format_error(r[1])
        case TEST_CASE_MEASURED_MATCHER:
            ret = formatter.format_measuring_test(r[1], r[2], r[3])
        case TEST_CASE_PENDING_MATCHER:
            ret = formatter.format_pending_test(r[1], r[2])
        case TEST_CASE_PASSED_MATCHER:
            ret = formatter.format_passing_test(r[1], r[2], r[3])
        case PODS_ERROR_MATCHER:
            ret = formatter.format_error(r[1])
        case PROCESS_INFO_PLIST_MATCHER:
            ret = formatter.format_process_info_plist(unescaped(r[2]), unescaped(r[1]))
        case PHASE_SCRIPT_EXECUTION_MATCHER:
            ret = formatter.format_phase_script_execution(unescaped(r[1]))
        case PHASE_SUCCESS_MATCHER:
            ret = formatter.format_phase_success(r[1])
        case PROCESS_PCH_MATCHER:
            ret = formatter.format_process_pch(r[1])
        case PROCESS_PCH_COMMAND_MATCHER:
            ret = formatter.format_process_pch_command(r[1])
        case PREPROCESS_MATCHER:
            ret = formatter.format_preprocess(r[1])
        case PBXCP_MATCHER:
            ret = formatter.format_pbxcp(r[1])
        case TESTS_RUN_COMPLETION_MATCHER:
            ret = formatter.format_test_run_finished(r[1], r[3])
        case TEST_SUITE_STARTED_MATCHER:
            ret = formatter.format_test_run_started(r[1])
        case TEST_SUITE_START_MATCHER:
            ret = formatter.format_test_suite_started(r[1])
        case TIFFUTIL_MATCHER:
            ret = formatter.format_tiffutil(r[1])
        case TOUCH_MATCHER:
            ret = formatter.format_touch(r[1], r[2])
        case WRITE_FILE_MATCHER:
            ret = formatter.format_write_file(r[1])
        case WRITE_AUXILIARY_FILES:
            ret = formatter.format_write_auxiliary_files()
        case SHELL_COMMAND_MATCHER:
            ret = formatter.format_shell_command(r[1], r[2])
        case GENERIC_WARNING_MATCHER:
            ret = formatter.format_warning(r[1])
        case WILL_NOT_BE_CODE_SIGNED_MATCHER:
            ret = formatter.format_will_not_be_code_signed(r[1])
        default:
            ret = formatter.format_other(text)
        }
        return ret
    }
    
    // MARK: Private Methods
    private func updateTestState(_ text:String) {
        let r = MatchSwitch(text)
        switch r {
        case TEST_SUITE_STARTED_MATCHER:
            testsDone = false
            formattedSummary = false
            failures.removeAll()
        case TEST_CASE_STARTED_MATCHER:
            testSuite = r[1]
            testCase = r[2]
        case TESTS_RUN_COMPLETION_MATCHER:
            testsDone = true
        case FAILING_TEST_MATCHER:
            storeFailure(file: r[1],
                         testSuite: r[2],
                         testCase: r[3],
                         reason: r[4])
        case UI_FAILING_TEST_MATCHER:
            storeFailure(file: r[1],
                         testSuite: testSuite,
                         testCase: testCase,
                         reason: r[2])
        case RESTARTING_TESTS_MATCHER:
            storeFailure(file: "n/a",
                         testSuite: testSuite,
                         testCase: testCase,
                         reason: "Test Crashed")
        default:
            ()
        }
    }
    
    private func updateErrorState(_ text: String) {
        let updateError = { (r:MatchSwitch) in
            self.currentIssue.reason = r[3]
            self.currentIssue.filePath = r[1]
            self.currentIssue.fileName = r[2]
        }

        let r = MatchSwitch(text)
        switch r {
        case COMPILE_ERROR_MATCHER:
            formattingError = true
            updateError(r)
        case COMPILE_WARNING_MATCHER:
            formattingWarning = true
            updateError(r)
        case CURSOR_MATCHER:
            currentIssue.cursor = r[1].strip()
        default:
            if formattingError || formattingWarning {
                currentIssue.line = text.strip()
            }
        }
    }
    
    private func updateLinkerFailureState(_ text: String) {
        let r = MatchSwitch(text)
        switch r {
        case LINKER_UNDEFINED_SYMBOLS_MATCHER:
            currentLinkerFailure.message = r[1]
            formattingLinkerFailure = true
        case LINKER_DUPLICATE_SYMBOLS_MATCHER:
            currentLinkerFailure.message = r[1]
            formattingLinkerFailure = true
        default: ()
        }
        if !formattingLinkerFailure {
            return
        }
        switch r {
        case SYMBOL_REFERENCED_FROM_MATCHER:
            currentLinkerFailure.symbol=r[1]
        case LINKER_UNDEFINED_SYMBOL_LOCATION_MATCHER:
            currentLinkerFailure.reference = text.strip()
        case LINKER_DUPLICATE_SYMBOLS_LOCATION_MATCHER:
            currentLinkerFailure.files.append(r[1])
        default: ()
        }
    }
    
    private func resetLinkerFormatState() {
        currentLinkerFailure = Issue()
        formattingLinkerFailure = false
    }
    
    var shouldFormatError: Bool {
        formattingError && errorOrWarningIsPresent
    }
    var shouldFormatWarning: Bool {
        formattingWarning && errorOrWarningIsPresent
    }
    var errorOrWarningIsPresent: Bool {
        currentIssue.reason != nil
            && currentIssue.cursor != nil
            && currentIssue.line != nil
    }
    var shouldFormatUndefinedSymbols: Bool {
        currentLinkerFailure.message != nil
            && currentLinkerFailure.symbol != nil
            && currentLinkerFailure.reference != nil
    }
    var shouldFormatDuplicateSymbols: Bool {
        currentLinkerFailure.message != nil
            && currentLinkerFailure.files.count > 1
    }
    private func formatCompileError() -> String {
        let error = currentIssue
        currentIssue = Issue()
        formattingError = false
        return formatter.format_compile_error(error.fileName ?? "",
                                              error.filePath ?? "",
                                              error.reason ?? "",
                                              error.line ?? "",
                                              error.cursor ?? "")
    }
    private func formatCompileWarning() -> String {
        let warning = currentIssue
        currentIssue = Issue()
        formattingWarning = false
        return formatter.format_compile_error(warning.fileName ?? "",
                                              warning.filePath ?? "",
                                              warning.reason ?? "",
                                              warning.line ?? "",
                                              warning.cursor ?? "")
    }
    private func formatUndefinedSymbols() -> String {
        let result = formatter.format_undefined_symbols(
            currentLinkerFailure.message ?? "",
            currentLinkerFailure.symbol ?? "",
            currentLinkerFailure.reference ?? "")
        resetLinkerFormatState()
        return result
    }
    
    private func formatDuplicatedSymbols() -> String {
        let result = formatter.format_duplicate_symbols(
            currentLinkerFailure.message ?? "",
            currentLinkerFailure.files
        )
        resetLinkerFormatState()
        return result
    }
    
    private func storeFailure(file: String, testSuite: String, testCase:String, reason: String) {
        var arr = failuresPerSuite[testSuite]
        var issue = Issue()
        issue.filePath = file
        issue.reason = reason
        issue.testCase = testCase
        if arr == nil {
            failuresPerSuite[testSuite] = [issue]
        } else {
            arr!.append(issue)
        }
    }

    func formatSummaryIfNeeded(_ executedMessage:String) -> String{
        if !shouldFormatSummary {
            return ""
        }
        formattedSummary = true
        return formatter.format_test_summary(executedMessage, failuresPerSuite)
    }
    
    var shouldFormatSummary: Bool {
        testsDone && formattedSummary
    }
    private func unescaped(_ text: String) -> String {
        return text.replacingOccurrences(of: "\\", with: "")
    }
}
