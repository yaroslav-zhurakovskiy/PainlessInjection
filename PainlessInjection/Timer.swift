//
//  Timer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public protocol TimerDelelgate: class {
    func onTick()
}

public protocol TimerProtocol {
    weak var delegate: TimerDelelgate? { get set }    
}


public protocol TimerFactoryProtocol {
    func newTimerWithInterval(interval: TimeInteval) -> TimerProtocol
}

public struct Timer {
    private static var _factory: TimerFactoryProtocol?
    public static var factory: TimerFactoryProtocol {
        get {
            if let factory = _factory {
                return factory
            }
            return StandardTimerFactory()
        }
        set {
            _factory = newValue
        }
    }
    
    public static func reset() {
        _factory = nil
    }
}