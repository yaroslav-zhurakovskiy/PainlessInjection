//
//  TimeInterval.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct TimeInterval {
    public let timeInterval: Double
    
    public init(seconds: Int) {
        timeInterval = Double(seconds)
    }
    
    public init(minutes: Int) {
        timeInterval = Double(minutes * 60)
    }
}
