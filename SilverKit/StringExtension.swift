//
//  StringExtension.swift
//  Mer Translator
//
//  Created by Jake Trimble on 7/1/17.
//  Copyright © 2017 Jake Trimble. All rights reserved.
//

import Foundation

infix operator § : MultiplicationPrecedence

public extension String {
    
    /// Because nobody likes .count
    public var length: Int {
        return self.count
    }
    
    public subscript (i: Int) -> String {
        return self[i..<(i + 1)]
    }
    
    /// Returns a segment of the string from the given index to the end
    public func substring(from: Int) -> String {
        return self[min(from, length) ..< length]
    }
    
    /// Returns a segment of the string from the beginning to the given index
    public func substring(to: Int) -> String {
        return self[0 ..< max(0, to)]
    }
    
    public subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        let t1 = self[start ..< end]
        return String(t1)
    }
    
    public func split (_ reg:String) -> [String]{
        return self.components(separatedBy: reg)
    }
    
    public static func § (lhs : String, rhs : String) -> [String] {
        return lhs.split(rhs)
    }
    
    /// Determines whether this String conforms to the given Regular Expression
    public func doesMatch(regex: String) -> Bool {
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
    
    /// Returns all of the indicies in this string of the specified character
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
