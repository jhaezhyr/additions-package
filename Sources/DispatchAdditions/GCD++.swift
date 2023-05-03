//
//  Dispatch Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/17/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Dispatch
import Foundation
import CoreGraphics

public typealias GCDCancelableClosure	= (_ cancel : Bool) -> ()
public typealias GCDClosure				= ()->()
public typealias GCDQueue				= DispatchQueue


/// The system provides you with a special serial queue known as the main queue. Like any serial queue, tasks in this queue execute one at a time. However, it’s guaranteed that all tasks will execute on the main thread, which is the only thread allowed to update your UI. This queue is the one to use for sending messages to UIView objects or posting notifications.
public var gGCDMainQueue:				GCDQueue
	{ return DispatchQueue.main }

/// The user interactive class represents tasks that need to be done immediately in order to provide a nice user experience. Use it for UI updates, event handling and small workloads that require low latency. The total amount of work done in this class during the execution of your app should be small.
@available(iOS 8.0, *)
@available(OSX 10.10, *)
public var gGCDUserInteractiveQueue:	GCDQueue
	{ return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive) }

/// The user initiated class represents tasks that are initiated from the UI and can be performed asynchronously. It should be used when the user is waiting for immediate results, and for tasks required to continue user interaction.
@available(iOS 8.0, *)
@available(OSX 10.10, *)
public var gGCDUserInitiatedQueue:		GCDQueue
	{ return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated) }

///  The utility class represents long-running tasks, typically with a user-visible progress indicator. Use it for computations, I/O, networking, continous data feeds and similar tasks. This class is designed to be energy efficient.
@available(iOS 8.0, *)
@available(OSX 10.10, *)
public var gGCDUtilityQueue:			GCDQueue
	{ return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility) }

///The background class represents tasks that the user is not directly aware of. Use it for prefetching, maintenance, and other tasks that don’t require user interaction and aren’t time-sensitive.
@available(iOS 8.0, *)
@available(OSX 10.10, *)
public var gGCDBackgroundQueue:			GCDQueue
	{ return DispatchQueue.global(qos: DispatchQoS.QoSClass.background) }


// MARK:  - Function Call Scheduling

public typealias dispatch_cancelable_closure = GCDCancelableClosure


/**
 **
 **
 **/
public func	scheduleFunctionCall(_ delay: CGFloat, call: @escaping () -> Void)
{
    DispatchQueue.main.asyncAfter(	deadline: DispatchTime.now() + Double(Int64(Double(delay) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
					execute: call	)
}


/**
 **
 **
 **/
public func	delay(_ time: TimeInterval, closure: @escaping GCDClosure) -> GCDCancelableClosure?
{
    func	dispatch_later(_ clsr:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(	deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
						execute: clsr	)
    }
	
    var closure:			(()->())?			= closure
    var cancelableClosure:	GCDCancelableClosure?
    let delayedClosure:		GCDCancelableClosure	=
	{
		cancel in
		
        if let clsr = closure
		{
            if (cancel == false)
			{
                DispatchQueue.main.async(execute: clsr);
            }
        }
        closure = nil
		cancelableClosure = nil
    }
	
    cancelableClosure = delayedClosure
	// Syntax here is calling `dispatch_later`
    dispatch_later
	{
        if let delayedClosure = cancelableClosure
		{
            delayedClosure(false)
        }
    }

    return cancelableClosure;
}


/// A synchronous wait function.  Don't use in main thread.
public func	wait(till condition: @autoclosure () -> Bool)
{
	while !condition()
	{
		
	}
}

public func	wait(forSeconds length: CGFloat)
{
	var ready = false
	scheduleFunctionCall(length) { ready = true }
	wait(till: ready)
}
