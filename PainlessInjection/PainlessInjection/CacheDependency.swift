//
//  CacheDependency.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class CacheDependency: Dependency, TimerDelelgate {
    
    private var _value: Any!
    private var _dependency: Dependency
    private let _timer: TimerProtocol
    init(dependency: Dependency, interval: TimeInterval) {
        _dependency = dependency
        _timer = Timer.factory.newTimerWithInterval(interval)
        _timer.delegate = self
    }
    
    var type: Any.Type {
        return _dependency.type
    }
    
    func create(args: [Any]) -> Any {
        if _value == nil {
            objc_sync_enter(self)
            _value = _dependency.create(args)
            _timer.start()
            objc_sync_exit(self)
        }
        return _value;
    }
    
    func onTick() {
        _value = nil
        _timer.stop()
    }
}
