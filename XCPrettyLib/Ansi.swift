//
//  Ansi.swift
//  XCPretty
//
//  Created by Steven Choi on 2020/2/29.
//  Copyright © 2020 Steven Choi. All rights reserved.
//

import Foundation

class ANSI {
    let FORMATTED_MATCHER = #"\#u{1B}\[(\d+)[;]?(\d+)?m(.*)\#u{1B}\[0m"#
    
    enum Effect : String, CustomStringConvertible {
        case reset = "0"
        case bold = "1"
        case underline = "4"
        var description: String {
            return self.rawValue
        }
    }
    enum Color : String, CustomStringConvertible {
        case black = "30"
        case red = "31"
        case green = "32"
        case yellow = "33"
        case blue = "34"
        case cyan = "36"
        case white = "37"
        case plain = "39"
        var description: String {
            return self.rawValue
        }
    }
    var colorize = true
    
    func parse(text: String, color: Color, effect: Effect? = nil) -> String{
        if !self.colorize {
            return text
        }
        let effectCode:String = effect != nil ? ";\(effect!)" : ""
        return "\u{1B}[\(color.rawValue)\(effectCode)m\(text)\u{1B}[\(Effect.reset)m"
    }
    
    func white(_ text: String) -> String {
        return parse(text: text, color: Color.plain, effect: .bold)
    }
    func red(_ text: String) -> String {
        return parse(text: text, color: Color.red)
    }
    func green(_ text: String) -> String {
        return parse(text: text, color: Color.green, effect: .bold)
    }
    func cyan(_ text: String) -> String {
        return parse(text: text, color: Color.cyan)
    }
    func yellow(_ text: String) -> String {
        return parse(text: text, color: Color.yellow)
    }
    func strip(_ text: String) -> String {
        if let matched = Regex(FORMATTED_MATCHER).match(text) {
            return matched[3]
        } else {
            return text
        }        
    }
    func appliedEffects(_ text: String) -> [String] {
        var effects = [String]()
        if let r = Regex(FORMATTED_MATCHER).match(text) {
            if let color = Color(rawValue:r[1]) {
                effects.append(color.rawValue)
            }
            if let effect = Effect(rawValue: r[2]) {
                effects.append(effect.rawValue)
            }
        }
        return effects
    }
}
