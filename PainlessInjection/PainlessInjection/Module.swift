//
//  Module.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public class Module: NSObject {
    
    public required override init() {
        super.init()
    }
    
    public func load() {
    
    }
    
    public func loadingPredicate() -> ModuleLoadingPredicate {
        return LoadModulePredicate()
    }
    
    public func define(type: Any.Type, configuration: () -> Any ) -> DefineDependencyStatement {
        let dependency = OnDemandDependency(type: type, configurator: { _ in configuration() })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    public func define(type: Any.Type, configuration: (ArgumentList) -> Any) -> DefineDependencyStatement {
        let dependency = OnDemandDependency(type: type, configurator: { (args: [Any]) in
            return configuration(ArgumentList(args: args))
        })
        Container.add(type, dependency: dependency)
        return DefineDependencyStatement(type: type, dependency: dependency)
    }
    
    public func resolve<T>(args: Any...) -> T {
        if args.count == 1 {
            return Container.get(args[0])
        }
        return Container.get(args)
    }
}