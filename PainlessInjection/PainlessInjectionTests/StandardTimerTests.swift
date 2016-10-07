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

func dispatchAfter(seconds: Int, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(UInt64(seconds) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
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
        let expectation = self.expectation(description: "Standard timer")
        dispatchAfter(seconds: TimerValueSeconds) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: Foundation.TimeInterval(TimerValueSeconds + 1)) { error in
            XCTAssertNil(error, "Shold not return any error.")
            delegateMock.assertCallOnTickOnce()
        }
    }
    
}
