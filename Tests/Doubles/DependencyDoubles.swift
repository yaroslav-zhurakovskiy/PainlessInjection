//
//  DependencyDoubles.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import PainlessInjection

class DependencySpy: Dependency {
    private(set) var numberOfCreationCalls = 0
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var type: Any.Type {
        return dependency.type
    }
    
    func create(_ args: [Any]) -> Any {
        numberOfCreationCalls += 1
        return dependency.create(args)
    }
}
