//
//  StandardTimer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

open class StandardTimer: NSObject, TimerProtocol {
    open weak var delegate: TimerDelelgate?
    
    private let timeInterval: TimeInterval
    
    public init(interval: TimeInterval) {
        timeInterval = interval
        super.init()
    }
    
    var nstimerVar: Foundation.Timer?
    open var nstimer: Foundation.Timer {
        get {
            if let timer = nstimerVar {
                return timer
            } else {
                return Foundation.Timer(
                    timeInterval: timeInterval.timeInterval,
                    target: self,
                    selector: #selector(onTimer),
                    userInfo: nil,
                    repeats: true)
            }
        }
        set {
            nstimerVar = newValue
        }
    }
    
    open func start() {
        self.nstimer.fire()
    }
    
    open func stop() {
        self.nstimer.invalidate()
    }
    
    deinit {
        self.nstimer.invalidate()
    }
    
    @objc open func onTimer() {
        delegate?.onTick()
    }
}

open class StandardTimerFactory: TimerFactoryProtocol {
    open func newTimerWithInterval(_ interval: TimeInterval) -> TimerProtocol {
        return StandardTimer(interval: interval)
    }
}
