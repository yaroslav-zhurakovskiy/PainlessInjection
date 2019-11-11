//
//  DefineConfigurator.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct DefineDependencyStatement {
    private var dependency: Dependency
    private let type: Any.Type
    
    init(type: Any.Type, dependency: Dependency) {
        self.type = type
        self.dependency = dependency
    }
    
    @discardableResult
    public func inSingletonScope() -> DefineDependencyStatement {
        let singletonDependency = SingletonDependency(dependency: dependency)
        Container.setDependency(singletonDependency, forType: type)
        return self
    }
    
    @discardableResult
    public func inCacheScope(interval: TimeInterval) -> DefineDependencyStatement {
        let singletonDependency = CacheDependency(dependency: dependency, interval: interval)
        Container.setDependency(singletonDependency, forType: type)
        return self
    }
    
    public func decorate(_ wrapper: (Dependency) -> Dependency) {
        if let dependency = Container.dependencyForType(type) {
            Container.setDependency(wrapper(dependency), forType: type)
        }
    }
}
