//
//  NSTimerDoubles.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import XCTest

class NSTimerSpy: Foundation.Timer {
    var fireWasCalledTimes: Int = 0
    var invalidateWasCalledTimes: Int = 0
    
    var spyTarget: AnyObject
    var spySelector: Selector
    var spyFireDate: Date
    var spyInterval: Foundation.TimeInterval
       
    override init(
       fireAt date: Date,
       interval: Foundation.TimeInterval,
       target: Any,
       selector: Selector,
       userInfo: Any?,
       repeats: Bool
    ) {
       self.spyTarget = target as AnyObject
       self.spySelector = selector
       self.spyFireDate = date
       self.spyInterval = interval
       super.init(
           fireAt: date,
           interval: interval,
           target: target,
           selector: selector,
           userInfo: userInfo,
           repeats: repeats
       )
    }
       
    override func fire() {
       fireWasCalledTimes += 1
    }
    
    override func invalidate() {
        invalidateWasCalledTimes += 1
    }
}

class NSTimerMock: NSTimerSpy {
    func assertFireWasCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            fireWasCalledTimes,
            times,
            "Number of fire() calls.",
            file: file,
            line: line
        )
    }
    
    func assertInvalidateCallTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            invalidateWasCalledTimes,
            times,
            "Number of invalidate() calls.",
            file: file,
            line: line
        )
    }
}
