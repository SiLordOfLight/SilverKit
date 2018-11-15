//
//  MTSDownloadTask.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/7/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

public class SlvDownloadTask : SlvTask{
    var url : URL
    var dest : String
    var next : SlvTaskContinueOption
    
    public init(download this:URL, to that:String, then contOpt:SlvTaskContinueOption) {
        url = this
        dest = that
        next = contOpt
    }
    
    public func execute() {
        SlvDownloadHelper.downloadFile(from: url, to: dest, then: {print("Complete")})
    }
    
    public func getContinueOption() -> SlvTaskContinueOption {
        return next
    }
    
    public func getDebugDescription() -> String {
        return "Download file from \(url) and save at Documents/\(dest), then \(next.rawValue)"
    }
}
