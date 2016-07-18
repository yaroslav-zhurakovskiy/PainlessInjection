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
    
    private let _timeInterval: TimeInteval
    private var _timer: NSTimer!
    
    public init(interval: TimeInteval) {
        _timeInterval = interval
        _timer = nil
        
        super.init()
        
        _timer = NSTimer.scheduledTimerWithTimeInterval(_timeInterval.timeInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    deinit {
        _timer.invalidate()
    }
    
    func onTimer() {
        delegate?.onTick()
    }
}

public class StandardTimerFactory: TimerFactoryProtocol {
    public func newTimerWithInterval(interval: TimeInteval) -> TimerProtocol {
        return StandardTimer(interval: interval)
    }
}
