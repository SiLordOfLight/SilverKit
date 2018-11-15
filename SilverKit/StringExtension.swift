//
//  StringExtension.swift
//  Mer Translator
//
//  Created by Jake Trimble on 7/1/17.
//  Copyright © 2017 Jake Trimble. All rights reserved.
//

import Foundation

infix operator § : MultiplicationPrecedence

extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        let t1 = self[start ..< end]
        return String(t1)
    }
    
    func split (_ reg:String) -> [String]{
        return self.components(separatedBy: reg)
    }
    
    static func § (lhs : String, rhs : String) -> [String] {
        return lhs.split(rhs)
    }
    
    func doesMatch(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.count > 0
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    func indices(of character:String) -> [Int] {
        var out:[Int] = []
        
        for i in 0..<self.count {
            if self[i] == character {
                out.append(i)
            }
        }
        
        return out
    }
    
    var isCapitalized:Bool { return self.capitalized == self }
}
