//
//  ArgumentListTests.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class ArgumentListTests: XCTestCase {
    
    var notifier: FatalErrorNotifierMock!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        notifier = FatalErrorNotifierMock()
        FatalErrorNotifier.currentNotifier = notifier
    }
    
    override func tearDown() {
        super.tearDown()
        
        FatalErrorNotifier.reset()
    }
    
    func testShouldRaiseTypeMistmatchError() {
        let list = ArgumentList(args: ["Hello"])
        let _: Int! = list.at(0)
        let file = #file
        let line = #line - 2
        
        notifier.assertLastMessage(
            expectedType: Int.self,
            receivedType: String.self,
            parameterIndex: 0,
            inFile: file,
            atLine: line
        )
    }
    
    func testShouldRaiseNoParameterError() {
        let list = ArgumentList(args: [])
        let _: NSDictionary! = list.at(0)
        let file = #file
        let line = #line - 2
        
        notifier.assertLastmessage(
            expectedType: NSDictionary.self,
            parameterIndex: 0,
            inFile: file,
            atLine: line
        )
    }
    
    func testShouldUseMultipleParams() {
        let list = ArgumentList(args: ["Hello", 12])
        
        let text: String = list.at(0)
        let number: Int = list.at(1)
        
        XCTAssertEqual(text, "Hello")
        XCTAssertEqual(number, 12)
        notifier.assertNotErrors()
        
    }
    
}
