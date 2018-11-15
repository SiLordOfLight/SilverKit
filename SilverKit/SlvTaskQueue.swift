//
//  MTSTaskQueue.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/7/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

enum SlvTaskContinueOption : String {
    case toBackground = "continue to another background task"
    case toUI = "continue to a UI task"
    case end = "end queue"
}

protocol SlvTask {
    func execute()
    
    func getDebugDescription() -> String
    
    func getContinueOption() -> SlvTaskContinueOption
}

class SlvTaskQueue {
    var tasks : [SlvTask]
    var taskSelected : Int
    var queueComplete : Bool
    var confirmedCompletion : Bool
    
    init() {
        tasks = []
        taskSelected = 0
        queueComplete = false
        confirmedCompletion = false
    }
    
    func addTask(_ tsk:SlvTask) {
        tasks.append(tsk)
    }
    
    func executeAll() {
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
//                    print("<BG Task>")
                    DispatchQueue.global(qos: .background).async(execute: self.continueQueue())
                
                case .toUI:
//                    print("<Main Task>")
                    DispatchQueue.main.async(execute: self.continueQueue())
                
                case .end:
                    return
            }
        }
    }
    
    func continueQueue() ->  () -> Void{
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
            
//            print(self.tasks[temI].getContinueOption().rawValue)
            
            switch self.tasks[temI].getContinueOption(){
                case .toBackground:
//                    print("<BG Task>")
                    DispatchQueue.global(qos: .background).async(execute: self.continueQueue())
                
                case .toUI:
//                    print("<Main Task>")
                    DispatchQueue.main.async(execute: self.continueQueue())
                
                case .end:
                    return
            }
        }
    }
    
}
