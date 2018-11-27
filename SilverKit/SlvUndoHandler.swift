//
//  UndoHandler.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/10/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

/// An action that can be undone and redone
/// - Author: Jake Trimble
/// - Version: 1.0.0
public protocol SlvUndoableAction {
    var isUndoCombinable : Bool {get}
    var actionID : String {get}
    func executeUndo()
    func executeRedo()
}

/// A group of undoable actions that have been combined into a single action
/// - Author: Jake Trimble
/// - Version: 1.0.0
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

/// A handler for storing a queue of actions to undo/redo
/// - Author: Jake Trimble
/// - Version: 1.0.0
public class SlvUndoHandler {
    var undoQueue : [SlvUndoableAction]
    var redoQueue : [SlvUndoableAction]
    var maximumQueueSize : Int
    
    /// Creates an empty undo/redo queue
    ///
    /// - Parameter maxSize: The maximum size of the queue, at which point the oldest actions are discarded
    public init (maxSize:Int){
        undoQueue = []
        redoQueue = []
        maximumQueueSize = maxSize
    }
    
    /// Adds an action to the undo queue and clears the redo queue
    public func actionHappened(_ action : SlvUndoableAction) {
        if undoQueue.count == maximumQueueSize {
            var temp = Array(undoQueue[1..<maximumQueueSize])
            temp.append(action)
            undoQueue = temp
        }else {
            undoQueue.append(action)
        }
        
        redoQueue.removeAll()
    }
    
    /// Executes the top action in the undo queue and moves it to the redo queue
    public func undo() {
        if let thisAction = undoQueue.popLast()  {
            thisAction.executeUndo()
            redoQueue.append(thisAction)
        }
    }
    
    /// Executes the top action in the redo queue and moves it to the undo queue
    public func redo() {
        if let thisAction = redoQueue.popLast() {
            thisAction.executeRedo()
            undoQueue.append(thisAction)
        }
    }
    
    /// Checks through the redo queue from the top and combines all similar actions into a `SlvUndoableActionGroup`
    public func combineRecent() {
        var comboID = ""
        if let lastAction = undoQueue.last {
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
            if let lastAct = undoQueue.last {
                if lastAct.actionID == comboID {
                    result.append(lastAct)
                    undoQueue.popLast()
                } else {
                    break
                }
            } else {
                break
            }
            
            if result.count > 0 {
                let combined = SlvUndoableActionGroup(result)
                undoQueue.append(combined)
            }
        }
    }
    
}

