//
//  MTSTaskQueue.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/7/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

public enum SlvTaskContinueOption : String {
    case toBackground = "continue to another background task"
    case toUI = "continue to a UI task"
    case end = "end queue"
}

/// A queued task that is executed completely before continuing to the next
public protocol SlvTask {
    func execute()
    
    func getDebugDescription() -> String
    
    func getContinueOption() -> SlvTaskContinueOption
}


/// A queue of `SlvTask`s that uses DispatchQueues background and main threads to execute data/UI tasks one at a time
/// - Author: Jake Trimble
/// - Version: 1.0.0
public class SlvTaskQueue {
    var tasks : [SlvTask]
    var taskSelected : Int
    var queueComplete : Bool
    public var confirmedCompletion : Bool
    
    public init() {
        tasks = []
        taskSelected = 0
        queueComplete = false
        confirmedCompletion = false
    }
    
    /// Adds a task to the queue
    /// - Note: The last task in the queue must have a .end continue option
    public func addTask(_ tsk:SlvTask) {
        tasks.append(tsk)
    }
    
    /// Executes all tasks in the queue asynchronously, using the main thread for UI tasks and the background thread for data tasks
    public func executeAll() {
        print("Tasks in queue: ")
        for i in 0..<tasks.count {
            print("\tTask #\(i): \(tasks[i].getDebugDescription()) -> \(tasks[i].getContinueOption().rawValue)")
        }
        print()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            
            print(">> Executing in the Background thread: \(self.tasks[0].getDebugDescription())")
            self.tasks[0].execute()
            
            
            self.taskSelected += 1
            
            switch self.tasks[0].getContinueOption(){
                case .toBackground:

                    DispatchQueue.global(qos: .background).async(execute: self.continueQueue())
                
                case .toUI:

                    DispatchQueue.main.async(execute: self.continueQueue())
                
                case .end:
                    return
            }
        }
    }
    
    fileprivate func continueQueue() ->  () -> Void{
        if queueComplete {
            return { return }
        }
        
        let temI = taskSelected
        taskSelected += 1
        if taskSelected == tasks.count {
            queueComplete = true
        }
        
        return { [weak self] in
            guard let self = self else {
                return
            }
            
            print(">> Executing in the \(self.tasks[temI-1].getContinueOption() == .toBackground ? "Background thread" : "Main thread"): \(self.tasks[temI].getDebugDescription())")
            self.tasks[temI].execute()
            

            
            switch self.tasks[temI].getContinueOption(){
                case .toBackground:

                    DispatchQueue.global(qos: .background).async(execute: self.continueQueue())
                
                case .toUI:

                    DispatchQueue.main.async(execute: self.continueQueue())
                
                case .end:
                    return
            }
        }
    }
    
}
