//
//  TimerDelegateDoubles.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import XCTest
import PainlessInjection

class TimerDelegatSpy: TimerDelelgate {
    private(set) var calls: Int = 0
       
    func onTick() {
       calls += 1
    }
}

class TimerDelegatMock: TimerDelegatSpy {
    func assertCallOnTickOnce(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            calls,
            1,
            "Number of onTick() calls.",
            file: file,
            line: line
        )
    }
}
