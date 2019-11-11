//
//  StandardTimer.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/18/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import XCTest
import PainlessInjection

let timerValueSeconds: Int = 2

extension Double {
    init(seconds: Int) {
        self = Double(Int64(UInt64(seconds) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
    }
}

func dispatchAfter(seconds: Int, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds)) {
        block()
    }
}

class StandardTimerTests: XCTestCase {
    
    var timer: StandardTimer!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        timer = StandardTimer(interval: TimeInterval(seconds: timerValueSeconds))
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
        defer {
            nstimerMock.assertInvalidateCallTimes(1)
        }
        timer.nstimer = nstimerMock
        timer = nil
    }
    
    func testShouldCallDelegateAfterDelay() {
        let delegateMock = FakeTimerDelegate()
        timer.delegate = delegateMock
        timer.start()
        let expectation = self.expectation(description: "Standard timer")
        dispatchAfter(seconds: timerValueSeconds) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: Foundation.TimeInterval(timerValueSeconds + 1)) { error in
            XCTAssertNil(error, "Shold not return any error.")
            delegateMock.assertCallOnTickOnce()
        }
    }
    
}
