//
//  MTSGenericTask.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/8/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

public class SlvGenericTask : SlvTask {
    var contOpt : SlvTaskContinueOption
    var body : () -> Void
    var description : String
    
    init(desc : String = "Generic Task", continuesTo : SlvTaskContinueOption, does : @escaping () -> Void) {
        contOpt = continuesTo
        body = does
        description = desc
    }
    
    func execute() {
        body()
    }
    
    func getContinueOption() -> SlvTaskContinueOption {
        return contOpt
    }
    
    func getDebugDescription() -> String {
        return description
    }
}
