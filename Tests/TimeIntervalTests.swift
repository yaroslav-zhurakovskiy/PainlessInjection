//
//  TimeIntervalTests.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class TimeIntervalTests: XCTestCase {

    func testSeconds() {
        let interval = TimeInterval(seconds: 1)
        
        XCTAssertEqual(interval.timeInterval, 1)
    }
    
    func testMinutes() {
        let interval = TimeInterval(minutes: 1)
        
        XCTAssertEqual(interval.timeInterval, 60)
    }
}
