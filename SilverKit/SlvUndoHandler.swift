//
//  UndoHandler.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/10/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

protocol SlvUndoableAction {
    var isUndoCombinable : Bool {get}
    var actionID : String {get}
    func executeUndo()
    func executeRedo()
}

class SlvUndoableActionGroup : SlvUndoableAction {
    var actions : [SlvUndoableAction]
    var actionID: String
    var isUndoCombinable: Bool = false
    
    init(_ acts:[SlvUndoableAction]){
        actions = acts
        actionID = acts[0].actionID + ":combined"
    }
    
    func executeUndo() {
        for act in actions{
            act.executeUndo()
        }
    }
    
    func executeRedo() {
        for act in actions {
            act.executeRedo()
        }
    }
}

class SlvUndoHandler {
    var queuedActions : [SlvUndoableAction]
    var availableToRedo : [SlvUndoableAction]
    var maximumQueueSize : Int
    
    init (maxSize:Int){
        queuedActions = []
        availableToRedo = []
        maximumQueueSize = maxSize
    }
    
    func actionHappened(_ action : SlvUndoableAction) {
        if queuedActions.count == maximumQueueSize {
            var temp = Array(queuedActions[1..<maximumQueueSize])
            temp.append(action)
            queuedActions = temp
        }else {
            queuedActions.append(action)
        }
        
        availableToRedo.removeAll()
    }
    
    func undo() {
        if let thisAction = queuedActions.popLast()  {
            thisAction.executeUndo()
            availableToRedo.append(thisAction)
        }
    }
    func redo() {
        if let thisAction = availableToRedo.popLast() {
            thisAction.executeRedo()
            queuedActions.append(thisAction)
        }
    }
    func combineRecent() {
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

