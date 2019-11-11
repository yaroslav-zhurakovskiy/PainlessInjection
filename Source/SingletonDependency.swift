//
//  Scope.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class SingletonDependency: Dependency {
    private var value: Any!
    private var dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var type: Any.Type {
        return dependency.type
    }
    
    func create(_ args: [Any]) -> Any {
        if value == nil {
            objc_sync_enter(self)
            value = dependency.create(args)
            objc_sync_exit(self)
        }
        return value as Any
    }
}
