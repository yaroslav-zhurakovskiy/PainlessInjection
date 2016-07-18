//
//  DefineConfigurator.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct DefineDependencyStatement {
    
    private var _dependency: Dependency
    private let _type: Any.Type
    init(type: Any.Type, dependency: Dependency) {
        _type = type
        _dependency = dependency
    }
    
    public func inSingletonScope() {
        let singletonDependency = SingletonDependency(dependency: _dependency)
        Container.setDependency(singletonDependency, forType: _type)
    }
    
    public func inCacheScope(interval interval: TimeInteval) {
        let singletonDependency = CacheDependency(dependency: _dependency, interval: interval)
        Container.setDependency(singletonDependency, forType: _type)
    }
    
    public func decorate(wrapper: (Dependency) -> Dependency) {
        if let dependency = Container.dependencyForType(_type) {
            Container.setDependency(wrapper(dependency), forType: _type)
        }
    }
}