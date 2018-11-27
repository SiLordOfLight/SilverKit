//
//  MTSDownloadTask.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/7/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

/**
 Represents a queued task to download a specified file
 
 - Author: Jake Trimble
 - Version: 1.0.0
 
*/
public class SlvDownloadTask : SlvTask{
    var url : URL
    var dest : String
    var next : SlvTaskContinueOption
    
    /// Creates a download task with it's given source and destination, as well as an indication of the task that follows in the queue
    ///
    /// - Parameters:
    ///   - this: The URL of the file to download
    ///   - that: The file path to save the downloaded file to
    ///   - contOpt: The type of the task that follows in the queue
    public init(download this:URL, to that:String, then contOpt:SlvTaskContinueOption) {
        url = this
        dest = that
        next = contOpt
    }
    
    /// Executes this task
    public func execute() {
        SlvDownloadHelper.downloadFile(from: url, to: dest, then: {print("Complete")})
    }
    
    
    /// Retrieve the type of the next task
    ///
    /// - Returns: The type of the next task
    public func getContinueOption() -> SlvTaskContinueOption {
        return next
    }
    
    /// Generates a description of this task
    ///
    /// - Returns: The debug description of this task
    public func getDebugDescription() -> String {
        return "Download file from \(url) and save at Documents/\(dest), then \(next.rawValue)"
    }
}
