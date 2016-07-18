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
        let timer = Timer.factory.newTimerWithInterval(TimeInteval(minutes: 1))
        
        XCTAssertTrue(timer is StandardTimer)
    }

}
