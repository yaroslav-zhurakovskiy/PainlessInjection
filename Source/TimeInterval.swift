//
//  TimeInterval.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct TimeInterval {
    fileprivate let _timeInterval: Double
    
    public init(seconds: Int) {
        _timeInterval = Double(seconds)
    }
    
    public init(minutes: Int) {
        _timeInterval = Double(minutes * 60)
    }
    
    public var timeInterval: Foundation.TimeInterval {
        return _timeInterval;
    }
}