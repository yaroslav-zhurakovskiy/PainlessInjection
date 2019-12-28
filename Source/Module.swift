//
//  Module.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

open class Module: NSObject {
    public required override init() {
        super.init()
    }
    
    open func load() {
    
    }
    
    open func loadingPredicate() -> ModuleLoadingPredicate {
        return LoadModulePredicate()
    }
    
    @discardableResult
    open func define<T>(_ type: T.Type, configuration: @escaping () -> T) -> DefineDependencyStatement<T> {
        let dependency = OnDemandDependency(type: type, configurator: { _ in configuration() })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    @discardableResult
    open func define<T>(_ type: T.Type, configuration: @escaping (ArgumentList) -> T) -> DefineDependencyStatement<T> {
        let dependency = OnDemandDependency(type: type, configurator: { (args: [Any]) in
            return configuration(ArgumentList(args: args))
        })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    open func resolve<T>(_ args: Any...) -> T {
        if args.count == 1 {
            return Container.get(args[0])
        }
        return Container.get(args)
    }
}
