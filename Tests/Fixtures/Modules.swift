//
//  Modules.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import PainlessInjection
import XCTest

class EmptyTestModule: Module {
    override func load() {
    }
}

class ModuleWithDependency: Module {
    var dependency: Dependency!
    
    required init() {
        super.init()
    }
    
    override func load() {
        define(String.self) { "Hello" } . decorate { dependency in
            self.dependency = dependency
            return dependency
        }
    }
    
    func assertDependencyType(_ type: Any.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            dependency.type == type,
            "Type should be String but got \(dependency.type)",
            file: file,
            line: line
        )

    }
}
