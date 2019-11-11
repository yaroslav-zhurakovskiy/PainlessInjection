//
//  FatalErrorNotifier.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class FataErrorNotifierTests: XCTestCase {
    
    func testShouldHaveDefaultErrorNotifier() {
        XCTAssertTrue(
            FatalErrorNotifier.currentNotifier is StandardFatalErrorNotifier,
            "FatalErrorNotifier.currentNotifier should be set as StandardFatalErrorNotifier."
        )
    }
}
