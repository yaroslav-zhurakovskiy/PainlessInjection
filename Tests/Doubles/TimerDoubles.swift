//
//  TimerDoubles.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import PainlessInjection
import XCTest

class TimerSpy: TimerProtocol {
    weak var delegate: TimerDelelgate?
       
    func timeout() {
       delegate?.onTick()
    }

    var startWasCalledTimes: Int = 0
    func start() {
       startWasCalledTimes += 1
    }

    var stopWasCalledTimes: Int = 0
    func stop() {
       stopWasCalledTimes += 1
    }
}

class TimerMock: TimerSpy {
    func assertStartWasCalledTimes(_ times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            startWasCalledTimes,
            times,
            "Number of start() calls.",
            file: file,
            line: line
        )
    }
    
    func assertStopWasCalledOnce(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            stopWasCalledTimes,
            1,
            "Number of stop() calls.",
            file: file,
            line: line
        )
    }
}

class TimerFactoryStub: TimerFactoryProtocol {
    private let timer: TimerProtocol
    
    init(timer: TimerProtocol) {
        self.timer = timer
    }
    
    func newTimerWithInterval(_ interval: PainlessInjection.TimeInterval) -> TimerProtocol {
        return timer
    }
}
