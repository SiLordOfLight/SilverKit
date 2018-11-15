//
//  UndoHandler.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/10/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

public protocol SlvUndoableAction {
    var isUndoCombinable : Bool {get}
    var actionID : String {get}
    func executeUndo()
    func executeRedo()
}

public class SlvUndoableActionGroup : SlvUndoableAction {
    var actions : [SlvUndoableAction]
    public var actionID: String
    public var isUndoCombinable: Bool = false
    
    public init(_ acts:[SlvUndoableAction]){
        actions = acts
        actionID = acts[0].actionID + ":combined"
    }
    
    public func executeUndo() {
        for act in actions{
            act.executeUndo()
        }
    }
    
    public func executeRedo() {
        for act in actions {
            act.executeRedo()
        }
    }
}

public class SlvUndoHandler {
    var queuedActions : [SlvUndoableAction]
    var availableToRedo : [SlvUndoableAction]
    var maximumQueueSize : Int
    
    public init (maxSize:Int){
        queuedActions = []
        availableToRedo = []
        maximumQueueSize = maxSize
    }
    
    public func actionHappened(_ action : SlvUndoableAction) {
        if queuedActions.count == maximumQueueSize {
            var temp = Array(queuedActions[1..<maximumQueueSize])
            temp.append(action)
            queuedActions = temp
        }else {
            queuedActions.append(action)
        }
        
        availableToRedo.removeAll()
    }
    
    public func undo() {
        if let thisAction = queuedActions.popLast()  {
            thisAction.executeUndo()
            availableToRedo.append(thisAction)
        }
    }
    public func redo() {
        if let thisAction = availableToRedo.popLast() {
            thisAction.executeRedo()
            queuedActions.append(thisAction)
        }
    }
    public func combineRecent() {
        var comboID = ""
        if let lastAction = queuedActions.last {
            if lastAction.isUndoCombinable {
                comboID = lastAction.actionID
            } else {
                return
            }
        } else {
            return
        }
        var result : [SlvUndoableAction] = []
        while true {
            if let lastAct = queuedActions.last {
                if lastAct.actionID == comboID {
                    result.append(lastAct)
                    queuedActions.popLast()
                } else {
                    break
                }
            } else {
                break
            }
            
            if result.count > 0 {
                let combined = SlvUndoableActionGroup(result)
                queuedActions.append(combined)
            }
        }
    }
    
}

