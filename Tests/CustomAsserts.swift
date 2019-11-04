//
//  CustomAsserts.swift
//  PainlessInjectionTests
//
//  Created by Yaroslav Zhurakovskiy on 3/30/19.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import XCTest

func AssertEqual<T: FloatingPoint>(_ val1: T, _ val2: T) {
    XCTAssertEqual(val1, val2, accuracy: 0.001 as! T)
}
