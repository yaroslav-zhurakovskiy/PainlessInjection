//
//  ModuleLoadingTests.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import XCTest
import PainlessInjection

class ModuleSpy: Module {
    static private(set) var calls: [AnyHashable: Int] = [:]
    
    override func load() {
        ModuleSpy.trackLoad()
    }
    
    static func reset() {
        calls.removeAll()
    }
    
    private static func trackLoad() {
        let key = keyForType()
        calls[key] = numberOfLoadCalls + 1
    }
    
    static var numberOfLoadCalls: Int {
        let key = keyForType()
        return calls[key] ?? 0
    }
    
    static func assertWasLoaded(times: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            numberOfLoadCalls,
            times,
            "Must be loaded \(times) times.",
            file: file,
            line: line
        )
    }
    
    private static func keyForType() -> AnyHashable {
        return "\(self)"
    }
}

class DoNotLoadPredicate: ModuleLoadingPredicate {
    func shouldLoadModule() -> Bool {
        return false
    }
}

class AutomaticModuleLoadingTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        Container.unload()
        ModuleSpy.reset()
    }
    
    func testShouldLoadModules() {
        Container.load()
        
        ModuleSpy.assertWasLoaded(times: 1)
        assertContainerContainsModule(ModuleSpy.self)
    }
    
    func testUnload() {
        Container.load()
        Container.unload()
        
        assertContainerDoesContainAnyModules()
    }
    
    func testModuleShouldNotBeLoaded() {
        class TestModule: ModuleSpy {
            override func loadingPredicate() -> ModuleLoadingPredicate {
                return DoNotLoadPredicate()
            }
        }
        TestModule.assertWasLoaded(times: 0)
        
        Container.load()
        
        TestModule.assertWasLoaded(times: 0)
        assertContainerDoesNotContainModule(TestModule.self)
    }
}

class ManualModuleLoadingTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        Container.unload()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Container.unload()
        ModuleSpy.reset()
    }
    
    func testShouldLoadModules() {
        ModuleSpy.assertWasLoaded(times: 0)
        
        Container.load([ModuleSpy.self])
        
        ModuleSpy.assertWasLoaded(times: 1)
        assertContainerContainsModule(ModuleSpy.self)
    }
    
    func testUnload() {
        Container.load([ModuleSpy.self])
        Container.unload()
        
        assertContainerDoesContainAnyModules()
    }
    
    func testModuleShouldNotBeLoaded() {
        class TestModule: ModuleSpy {
            override func loadingPredicate() -> ModuleLoadingPredicate {
                return DoNotLoadPredicate()
            }
        }
        
        Container.load([TestModule.self])
        
        TestModule.assertWasLoaded(times: 0)
        assertContainerDoesNotContainModule(TestModule.self)
    }
}

func assertContainerDoesContainAnyModules(
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(Container.loadedModules.count, 0, "Number of modules", file: file, line: line)
}

func assertContainerContainsModule<T: Module>(
    _ module: T.Type,
    file: StaticString = #file,
    line: UInt = #line
) {
    let foundModule = Container.loadedModules.compactMap { $0 as? T }.first
    let names = Container.loadedModules.map { formatModuleName($0) }
    let modulesList = formatArray(names)
    let moduleName = formatModuleName(module.init())
    XCTAssertNotNil(
        foundModule,
        "\(modulesList) should contain \(moduleName)",
        file: file,
        line: line
    )
}

func assertContainerDoesNotContainModule<T: Module>(
    _ module: T.Type,
    file: StaticString = #file,
    line: UInt = #line
) {
    let foundModule = Container.loadedModules.compactMap { $0 as? T }.first
    let names = Container.loadedModules.map { formatModuleName($0) }
    let modulesList = formatArray(names)
    let moduleName = formatModuleName(module.init())
    XCTAssertNil(
        foundModule,
        "\(modulesList) should not contain \(moduleName)",
        file: file,
        line: line
    )
}

private func formatModuleName<T: Module>(_ module: T) -> String {
    return "\(module)"
}

private func formatArray(_ list: [String]) -> String {
    if list.isEmpty {
        return "[]"
    } else {
        return "[\n\t" + list.joined(separator: ",\n") + "]"
    }
}
