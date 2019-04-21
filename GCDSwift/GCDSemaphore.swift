import Foundation

public class GCDSemaphore {
 /**
  *  Returns the underlying dispatch semaphore object.
  *
  *  - returns: The dispatch semaphore object.
  */
    
  public let dispatchSemaphore:DispatchSemaphore

  // MARK: Lifecycle
  
 /**
  *  Initializes a new semaphore with starting value 0.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_semaphore_create()
  */
  public convenience init() {
    self.init(value: 0)
  }

 /**
  *  Initializes a new semaphore.
  *
  *  - parameter value: The starting value for the semaphore.
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_semaphore_create()
  */
  public convenience init(value: Int) {
    self.init(dispatchSemaphore: DispatchSemaphore(value: value))
  }

 /**
  *  The GCDSemaphore designated initializer.
  *
  *  - parameter dispatchSemaphore: A dispatch_semaphore_t object.
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_semaphore_create()
  */
  public init(dispatchSemaphore: DispatchSemaphore) {
    self.dispatchSemaphore = dispatchSemaphore
  }

  // MARK: Public methods
  
 /**
  *  Signals (increments) the semaphore.
  *
  *  - returns: `true` if a thread is awoken, `false` otherwise.
  *  - SeeAlso: dispatch_semaphore_signal()
  */
  public func signal() -> Bool {
    return self.dispatchSemaphore.signal() != 0
  }

 /**
  *  Waits forever for (decrements) the semaphore.
  *
  *  - SeeAlso: dispatch_semaphore_wait()
  */
  public func wait() {
    self.dispatchSemaphore.wait()
  }
  
 /**
  *  Waits for (decrements) the semaphore.
  *
  *  - parameter seconds: The time to wait in seconds.
  *  - returns: `true` on success, `false` if the timeout occurred.
  *  - SeeAlso: dispatch_semaphore_wait()
  */
  public func wait(seconds: TimeInterval) -> Bool {
    let when = DispatchTime.now() + seconds
    return self.dispatchSemaphore.wait(timeout: when) == .success
  }
}
