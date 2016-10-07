//
//  Scope.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class SingletonDependency: Dependency {
    fileprivate var _value: Any!
    fileprivate var _dependency: Dependency
    init(dependency: Dependency) {
        _dependency = dependency
    }
    
    var type: Any.Type {
        return _dependency.type
    }
    
    func create(_ args: [Any]) -> Any {
        if _value == nil {
            objc_sync_enter(self)
            _value = _dependency.create(args)
            objc_sync_exit(self)
        }
        return _value;
    }
}
