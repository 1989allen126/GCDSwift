import Foundation

public class GCDQueue {
 /**
  *  Returns the underlying dispatch queue object.
  *
  *  - returns: The dispatch queue object.
  */
  public let dispatchQueue: DispatchQueue
  
  // MARK: Global queue accessors
  
 /**
  *  Returns the serial dispatch queue associated with the application’s main thread.
  *
  *  - returns: The main queue. This queue is created automatically on behalf of the main thread before main is called.
  *
  *  - SeeAlso: dispatch_get_main_queue()
  */
  public class var mainQueue: GCDQueue {
    return GCDQueue(dispatchQueue: DispatchQueue.main)
  }

 /**
  *  Returns the default priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var globalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: DispatchQueue.global())
  }

 /**
  *  Returns the high priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var highPriorityGlobalQueue: GCDQueue {
    
    return GCDQueue(dispatchQueue: DispatchQueue.global(qos:.userInitiated))
  }

 /**
  *  Returns the low priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var lowPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.utility))
  }

 /**
  *  Returns the background priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var backgroundPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background))
  }
  
  // MARK: Lifecycle
  
 /**
  *  Initializes a new serial queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public class func serialQueue() -> GCDQueue {
    
    return GCDQueue(dispatchQueue: DispatchQueue(label: ""))
  }
  
 /**
  *  Initializes a new concurrent queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public class func concurrentQueue() -> GCDQueue {
    return GCDQueue(dispatchQueue: DispatchQueue(label: "", qos:.default, attributes: .concurrent, autoreleaseFrequency:.inherit, target:nil))
  }
  
 /**
  *  Initializes a new serial queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public convenience init() {
    self.init(dispatchQueue: DispatchQueue(label: ""))
  }
  
 /**
  *  The GCDQueue designated initializer.
  *
  *  - parameter dispatchQueue: dispatch_queue_t object.
  *  - returns: The initialized instance.
  */
  public init(dispatchQueue: DispatchQueue) {
    self.dispatchQueue = dispatchQueue
  }
  
  // MARK: Public block methods
  
 /**
  *  Submits a block for asynchronous execution on the queue.
  *
  *  - parameter block: The block to submit.
  *
  *  - SeeAlso: dispatch_async()
  */
  public func queueBlock(_ block: @escaping @convention(block) () -> Void) {
    self.dispatchQueue.async(execute: block)
  }
  
 /**
  *  Submits a block for asynchronous execution on the queue after a delay.
  *
  *  - parameter block: The block to submit.
  *  - parameter afterDelay: The delay in seconds.
  *  - SeeAlso: dispatch_after()
  */
  public func queueBlock(_ block: @escaping @convention(block) () -> Void, afterDelay seconds: TimeInterval) {
    let when = DispatchTime.now() + seconds
    DispatchQueue.global().asyncAfter(deadline: when, execute: block)
  }
  
 /**
  *  Submits a block for execution on the queue and waits until it completes.
  *
  *  - parameter block: The block to submit.
  *  - SeeAlso: dispatch_sync()
  */
  public func queueAndAwaitBlock(_ block: @escaping @convention(block) () -> Void) {
    self.dispatchQueue.sync(execute: block)
  }
  
 /**
  *  Submits a block for execution on the queue multiple times and waits until all executions complete.
  *
  *  - parameter block: The block to submit.
  *  - parameter iterationCount: The number of times to execute the block.
  *  - SeeAlso: dispatch_apply()
  */
  public func queueAndAwaitBlock(_ block: ((Int) -> Void), iterationCount count: Int) {
    DispatchQueue.concurrentPerform(iterations: count, execute: block)
  }
  
 /**
  *  Submits a block for asynchronous execution on the queue and associates it with the group.
  *
  *  - parameter block: The block to submit.
  *  - parameter inGroup: The group to associate the block with.
  *  - SeeAlso: dispatch_group_async()
  */
  public func queueBlock(_ block:  @escaping @convention(block) () -> Void, inGroup group: GCDGroup) {
    self.dispatchQueue.async(group: group.dispatchGroup, execute: block)
  }
 
 /**
  *  Schedules a block to be submitted to the queue when a group of previously submitted blocks have completed.
  *
  *  - parameter block: The block to submit when the group completes.
  *  - parameter inGroup: The group to observe.
  *  - SeeAlso: dispatch_group_notify()
  */
  public func queueNotifyBlock(_ block:  @escaping @convention(block) () -> Void, inGroup group: GCDGroup) {
    group.dispatchGroup.notify(queue: self.dispatchQueue, execute: block)
  }
  
 /**
  *  Submits a barrier block for asynchronous execution on the queue.
  *
  *  - parameter block: The barrier block to submit.
  *  - SeeAlso dispatch_barrier_async()
  */
  public func queueBarrierBlock(_ block:  @escaping @convention(block) () -> Void) {
    self.dispatchQueue.async(group: nil, qos: DispatchQoS.default, flags: DispatchWorkItemFlags.barrier, execute: block)
  }
  
 /**
  *  Submits a barrier block for execution on the queue and waits until it completes.
  *
  *  - parameter block: The barrier block to submit.
  *  - SeeAlso: dispatch_barrier_sync()
  */
  public func queueAndAwaitBarrierBlock(_ block:  @escaping @convention(block) () -> Void) {
    self.dispatchQueue.sync(flags: .barrier, execute: block)
  }
  
  // MARK: Misc public methods
  
 /**
  *  Suspends execution of blocks on the queue.
  *
  *  - SeeAlso: dispatch_suspend()
  */
  public func suspend() {
    dispatchQueue.suspend()
  }
  
 /**
  *  Resumes execution of blocks on the queue.
  *
  *  - SeeAlso: dispatch_resume()
  */
  public func resume() {
    dispatchQueue.resume()
  }
}
