//
//  AutoinjectTests.swift
//  PainlessInjectionTests
//
//  Created by Yaroslav Zhurakovskiy on 04.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

#if swift(>=5)
import PainlessInjection
import XCTest

fileprivate class AutoinjecteServiceUser: Module {
    @Inject var service: ServiceProtocol
}

class AutoinjectTests: XCTestCase {
    var errorNotifier: TestFatalErrorNotifier!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        class TestModule: Module {
            override func load() {
                define(ServiceProtocol.self) { Service() }
            }
        }

        TestModule().load()
        errorNotifier = TestFatalErrorNotifier()
        FatalErrorNotifier.currentNotifier = errorNotifier
    }
    
    override class func tearDown() {
        Container.unload()
        FatalErrorNotifier.reset()
        
        super.tearDown()
    }

    func testAutowiring() {
        let user = AutoinjecteServiceUser()
        
        XCTAssertTrue(user.service is Service, "service must be autowired to \(Service.self) but got \(type(of: user.service))")
    }
}


#endif
