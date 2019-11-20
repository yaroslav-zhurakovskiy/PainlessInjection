//
//  Module.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import ObjectiveC

public protocol ModuleTrait {
    init()
    
    func load()
    
    func loadingPredicate() -> ModuleLoadingPredicate
    @discardableResult
    func define(_ type: Any.Type, configuration: @escaping () -> Any ) -> DefineDependencyStatement
    @discardableResult
    func define(_ type: Any.Type, configuration: @escaping (ArgumentList) -> Any) -> DefineDependencyStatement
    func resolve<T>(_ args: Any...) -> T
}

public extension ModuleTrait {
    func load() {
        
    }
    
    func loadingPredicate() -> ModuleLoadingPredicate {
        return LoadModulePredicate()
    }
    
    @discardableResult
    func define(_ type: Any.Type, configuration: @escaping () -> Any ) -> DefineDependencyStatement {
        let dependency = OnDemandDependency(type: type, configurator: { _ in configuration() })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    @discardableResult
    func define(_ type: Any.Type, configuration: @escaping (ArgumentList) -> Any) -> DefineDependencyStatement {
        let dependency = OnDemandDependency(type: type, configurator: { (args: [Any]) in
            return configuration(ArgumentList(args: args))
        })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    func resolve<T>(_ args: Any...) -> T {
        if args.count == 1 {
            return Container.get(args[0])
        }
        return Container.get(args)
    }
}

#if canImport(ObjectiveC)
open class Module: NSObject, ModuleTrait {
    public required override init() {
        super.init()
    }
}
#else
open class Module: ModuleTrait {

}
#endif
