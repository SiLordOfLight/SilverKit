//
//  GateOperators.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 10/9/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

infix operator *| : MultiplicationPrecedence
infix operator !| : MultiplicationPrecedence
infix operator !& : MultiplicationPrecedence
infix operator !* : MultiplicationPrecedence

public extension Bool {
    static func *| (lhs : Bool, rhs : Bool) -> Bool {
        return ( lhs || rhs ) && !( lhs && rhs )
    }
    
    static func !| (lhs : Bool, rhs : Bool) -> Bool {
        return !lhs && !rhs
    }
    
    static func !& (lhs : Bool, rhs : Bool) -> Bool {
        return (lhs *| rhs) || (lhs !| rhs)
    }
    
    static func !* (lhs : Bool, rhs : Bool) -> Bool {
        return ( lhs !| rhs ) || ( lhs && rhs )
    }
}
