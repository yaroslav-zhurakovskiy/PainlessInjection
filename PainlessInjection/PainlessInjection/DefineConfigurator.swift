//
//  DefineConfigurator.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct DefineDependencyStatement {
    
    fileprivate var _dependency: Dependency
    fileprivate let _type: Any.Type
    init(type: Any.Type, dependency: Dependency) {
        _type = type
        _dependency = dependency
    }
    
    @discardableResult
    public func inSingletonScope() -> DefineDependencyStatement {
        let singletonDependency = SingletonDependency(dependency: _dependency)
        Container.setDependency(singletonDependency, forType: _type)
        return self
    }
    
    @discardableResult
    public func inCacheScope(interval: TimeInterval) -> DefineDependencyStatement {
        let singletonDependency = CacheDependency(dependency: _dependency, interval: interval)
        Container.setDependency(singletonDependency, forType: _type)
        return self
    }
    
    public func decorate(_ wrapper: (Dependency) -> Dependency) {
        if let dependency = Container.dependencyForType(_type) {
            Container.setDependency(wrapper(dependency), forType: _type)
        }
    }
}
