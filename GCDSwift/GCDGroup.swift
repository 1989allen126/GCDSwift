import Foundation

public class GCDGroup {
 /**
  *  Returns the underlying dispatch group object.
  *
  *  - returns: The dispatch group object.
  */
  public let dispatchGroup: DispatchGroup
  
  // MARK: Lifecycle
  
 /**
  *  Initializes a new group.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_group_create()
  */
  public convenience init() {
    self.init(dispatchGroup: DispatchGroup())
  }
  
 /**
  *  The GCDGroup designated initializer.
  *
  *  - parameter dispatchGroup: A dispatch_group_t object.
  *  - returns: The initialized instance.
  */
  public init(dispatchGroup: DispatchGroup) {
    self.dispatchGroup = dispatchGroup
  }
  
  // MARK: Public methods
  
 /**
  *  Explicitly indicates that a block has entered the group.
  *
  *  - SeeAlso: dispatch_group_enter()
  */
  public func enter() {
    return self.dispatchGroup.enter()
  }

 /**
  *  Explicitly indicates that a block in the group has completed.
  *
  *  - SeeAlso: dispatch_group_leave()
  */
  public func leave() {
    return self.dispatchGroup.leave()
  }

 /**
  *  Waits forever for the previously submitted blocks in the group to complete.
  *
  *  - SeeAlso: dispatch_group_wait()
  */
  public func wait() {
    let when = DispatchTime.distantFuture
    let _ = self.dispatchGroup.wait(timeout: when)
  }
  
/**
  *  Waits for the previously submitted blocks in the group to complete.
  *
  *  - parameter seconds: The time to wait in seconds.
  *  - returns: `true` if all blocks completed, `false` if the timeout occurred.
  *  - SeeAlso: dispatch_group_wait()
  */
  public func wait(seconds: TimeInterval) -> Bool {
    let when = DispatchTime.now() + seconds
    return self.dispatchGroup.wait(timeout: when) == .success
  }
}
