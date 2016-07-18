//
//  TimerTests.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class TimerTests: XCTestCase {
    
    func testShouldHaveDefaultTimer() {
        let timer = Timer.factory.newTimerWithInterval(TimeInterval(minutes: 1))
        
        XCTAssertTrue(timer is StandardTimer, "Expected StandardTimer but got \(timer.self)")
    }

}
