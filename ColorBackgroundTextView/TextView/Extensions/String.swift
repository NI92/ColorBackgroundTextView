//
//  String.swift
//  ColorBackgroundTextView
//
//  Created by Nick Ignatenko on 2021-01-04.
//

import UIKit

extension String {
    
    func substring(with range: NSRange) -> String {
        return substring(from: range.location, lenght: range.length)
    }
    
    func substring(to: Int) -> String {
        if to >= count {
            return self
        }
        let end = index(endIndex, offsetBy: to - count)
        return String(self[..<end])
    }
    
    func substring(from: Int) -> String {
        if from >= count {
            return self
        }
        let start = index(startIndex, offsetBy: from)
        return String(self[start...])
    }
    
    func substring(from: Int, to: Int) -> String {
        return substring(to: to).substring(from: from)
    }
    
    func substring(from: Int, lenght: Int) -> String {
        return substring(from: from, to: from + lenght)
    }
    
    func fullRange() -> NSRange {
        return NSRange(location: 0, length: count)
    }
    
    func rangeOfString(_ string: String) -> NSRange? {
        return rangesOfString(string).first
    }
    
    func rangesOfString(_ string: String) -> [NSRange] {
        let expression = try! NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: string), options: [])
        return expression.matches(in: self, options: [], range: fullRange()).map { $0.range }
    }
    
}
