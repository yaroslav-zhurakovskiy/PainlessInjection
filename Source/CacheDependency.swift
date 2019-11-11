//
//  CacheDependency.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class CacheDependency: Dependency, TimerDelelgate {
    private var value: Any!
    private var dependency: Dependency
    private var timer: TimerProtocol
    
    init(dependency: Dependency, interval: TimeInterval) {
        self.dependency = dependency
        self.timer = Timer.factory.newTimerWithInterval(interval)
        self.timer.delegate = self
    }
    
    var type: Any.Type {
        return dependency.type
    }
    
    func create(_ args: [Any]) -> Any {
        if value == nil {
            objc_sync_enter(self)
            value = dependency.create(args)
            timer.start()
            objc_sync_exit(self)
        }
        return value as Any
    }
    
    func onTick() {
        value = nil
        timer.stop()
    }
}
