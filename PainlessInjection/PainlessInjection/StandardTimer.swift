//
//  StandardTimer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public class StandardTimer: NSObject, TimerProtocol {
    public var delegate: TimerDelelgate?
    
    private let _timeInterval: TimeInterval
    
    public init(interval: TimeInterval) {
        _timeInterval = interval
        super.init()
    }
    
    var _nstimer:NSTimer?
    public var nstimer: NSTimer {
        get {
            if let timer = _nstimer {
                return timer
            }
            return NSTimer(timeInterval: _timeInterval.timeInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        }
        set {
            _nstimer = newValue
        }
    }
    
    public func start() {
        self.nstimer.fire()
    }
    
    public func stop() {
        self.nstimer.invalidate()
    }
    
    deinit {
        self.nstimer.invalidate()
    }
    
    public func onTimer() {
        delegate?.onTick()
    }
}

public class StandardTimerFactory: TimerFactoryProtocol {
    public func newTimerWithInterval(interval: TimeInterval) -> TimerProtocol {
        return StandardTimer(interval: interval)
    }
}
