//
//  MTSGenericTask.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/8/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

/**
 A queued task with an open-ended execution
 
 - Author: Jake Trimble
 - Version: 1.0.0
 
 */
public class SlvGenericTask : SlvTask {
    var contOpt : SlvTaskContinueOption
    var body : () -> Void
    var description : String
    
    /// Creates a generic queued task
    ///
    /// - Parameters:
    ///   - desc: An optional string description of the task
    ///   - continuesTo: The type of the next task in the queue
    ///   - does: A non-returning no-parameter closure that defines the task's execution
    public init(desc : String = "Generic Task", continuesTo : SlvTaskContinueOption, does : @escaping () -> Void) {
        contOpt = continuesTo
        body = does
        description = desc
    }
    
    public func execute() {
        body()
    }
    
    public func getContinueOption() -> SlvTaskContinueOption {
        return contOpt
    }
    
    public func getDebugDescription() -> String {
        return description
    }
}
