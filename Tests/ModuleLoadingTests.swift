//
//  ModuleLoadingTests.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection


class ModuleLoadingTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        Container.unload();
    }
    
    func testShouldLoadModules() {
        class TestModule: Module {
            static var loaded = false
            override func load() {
                TestModule.loaded = true
            }
            
            class func assertWasLoaded(_ file: StaticString = #file, line: UInt = #line) {
                XCTAssertTrue(loaded, "Module \(type(of: self)) must be loaded.", file: file, line: line)
            }
            
            class func assertWasNotLoaded(_ file: StaticString = #file, line: UInt = #line) {
                XCTAssertFalse(loaded, "Module \(type(of: self)) must not be loaded.", file: file, line: line)
            }
        }
        
        Container.load()
        
        TestModule.assertWasLoaded()
        XCTAssertTrue(Container.loadedModules.contains("\(TestModule.self)"))
    }
    
    func testUnload() {
        class TestModule: Module {
            static var loaded = false
            override func load() {
                TestModule.loaded = true
            }
            
            class func assertWasLoaded(_ file: StaticString = #file, line: UInt = #line) {
                XCTAssertTrue(loaded, "Module \(type(of: self)) must be loaded.", file: file, line: line)
            }
        }
        
        Container.load()
        Container.unload()
        
        XCTAssertTrue(Container.loadedModules.count == 0)
    }
    
    func testModuleShouldNotBeLoaded() {
        class DoNotLoadPredicate: ModuleLoadingPredicate {
            func shouldLoadModule() -> Bool {
                return false
            }
        }
        class TestModule: Module {
            static var loaded = false
            override func load() {
                TestModule.loaded = true
            }
            override func loadingPredicate() -> ModuleLoadingPredicate {
                return DoNotLoadPredicate()
            }
            
            class func assertWasNotLoaded(_ file: StaticString = #file, line: UInt = #line) {
                XCTAssertFalse(loaded, "Module \(type(of: self)) must not be loaded.", file: file, line: line)
            }
        }
        
        Container.load()
        
        TestModule.assertWasNotLoaded()
        XCTAssertFalse(Container.loadedModules.contains("\(DoNotLoadPredicate.self)"))
    }
}
