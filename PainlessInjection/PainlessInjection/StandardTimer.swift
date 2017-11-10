//
//  StandardTimer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

open class StandardTimer: NSObject, TimerProtocol {
    open var delegate: TimerDelelgate?
    
    fileprivate let _timeInterval: TimeInterval
    
    public init(interval: TimeInterval) {
        _timeInterval = interval
        super.init()
    }
    
    var _nstimer:Foundation.Timer?
    open var nstimer: Foundation.Timer {
        get {
            if let timer = _nstimer {
                return timer
            } else {
                return Foundation.Timer(
                    timeInterval: _timeInterval.timeInterval,
                    target: self,
                    selector: #selector(onTimer),
                    userInfo: nil,
                    repeats: true)
            }
        }
        set {
            _nstimer = newValue
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
