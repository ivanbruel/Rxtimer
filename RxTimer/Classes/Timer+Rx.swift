//
//  NSTimer+Rx.swift
//
//  Created by Ivan Bruel on 20/07/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift

public extension Timer {

  class var rx_timer: Observable<Void> {
    return rx_timer(1.0)
  }

  class func rx_timer(_ time: TimeInterval) -> Observable<Void> {
    return Observable<Void>.create { observer in
      observer.onNext(())
      let timer = Timer.schedule(repeatInterval: time) {
        observer.onNext(())
      }
      return Disposables.create {
        observer.onCompleted()
        timer.invalidate()
      }
    }
  }
}

private extension Timer {
  /*
   Creates and schedules a one-time `NSTimer` instance.

   - Parameters:
   - delay: The delay before execution.
   - handler: A closure to execute after `delay`.
   - Returns: The newly-created `NSTimer` instance.
   */
  class func schedule(delay: TimeInterval, handler: @escaping ()->()) -> Timer {
    let fireDate = delay + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0) { theTimer in
      handler()
    }
    
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    return timer!
  }
  
  /*
   Creates and schedules a repeating `NSTimer` instance.

   - Parameters:
   - repeatInterval: The interval (in seconds) between each execution of
   `handler`. Note that individual calls may be delayed; subsequent calls
   to `handler` will be based on the time the timer was created.
   - handler: A closure to execute at each `repeatInterval`.
   - Returns: The newly-created `NSTimer` instance.
   */
  class func schedule(repeatInterval interval: TimeInterval, handler: @escaping () -> Void)
    -> Timer {
      let fireDate = interval + CFAbsoluteTimeGetCurrent()
      let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0) {
        theTimer in
        handler()
      }
      
      CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
      return timer!
  }
}
