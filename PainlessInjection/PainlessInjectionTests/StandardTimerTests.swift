//
//  StandardTimer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/18/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

let TimerValueSeconds: Int = 2

func dispatchAfter(seconds seconds: Int, block: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(seconds) * NSEC_PER_SEC)), dispatch_get_main_queue()) {
        block()
    }
    
}


class StandardTimerTests: XCTestCase {
    
    var timer: StandardTimer!
    
    override func setUp() {
        super.setUp()
        
        timer = StandardTimer(interval: TimeInterval(seconds: TimerValueSeconds))
    }
    
    func testSmoke() {
        XCTAssertNotNil(timer)
    }
    
    func testShouldInvalidateOnStop() {
        let nstimerMock = FakeNSTimer()
        timer.nstimer = nstimerMock
        timer.stop()
        
        nstimerMock.assertInvalidateCallTimes(1)
    }
    
    func testShouldInvalidateOnDealloc() {
        let nstimerMock = FakeNSTimer()
        timer.nstimer = nstimerMock
        timer = nil
        
        defer {
            nstimerMock.assertInvalidateCallTimes(1)
        }
    }
    
    func testShouldCallDelegateAfterDelay() {
        let delegateMock = FakeTimerDelegate()
        timer.delegate = delegateMock
        timer.start()
        let expectation = expectationWithDescription("Standard timer")
        dispatchAfter(seconds: TimerValueSeconds) {
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(NSTimeInterval(TimerValueSeconds + 1)) { error in
            XCTAssertNil(error, "Shold not return any error.")
            delegateMock.assertCallOnTickOnce()
        }
    }
    
}
