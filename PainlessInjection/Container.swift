//
//  Container.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import PainlessInjectionLoader

public struct Container {
    
    private static var _dependencies: [String: Dependency] = [:]
    private static var _modules: [Module] = []
    
    internal static func add(type: Any.Type, dependency: Dependency) {
        let name = "\(type)"
        if _dependencies[name] == nil {
            _dependencies[name] = dependency
        }
    }
    
    internal static func setDependency(dependency: Dependency, forType type: Any.Type) {
        let name = "\(type)"
        _dependencies[name] = dependency
    }
    
    internal static func dependencyForType(type: Any.Type) -> Dependency? {
        let name = "\(type)"
        return _dependencies[name]
    }
    
    public static func load() {
        if let modules = PIModuleLoader.listWithType(Module.self) as? [Module] {
            _modules = modules.flatMap { module in module.loadingPredicate().shouldLoadModule() ? module : nil }
            _modules.forEach { module in
                module.load()
            }
        }
    }
    
    public static func get<T>(args: Any...) -> T! {
        let name = "\(T.self)"
        if let dependency = _dependencies[name] {
            return dependency.create(args.map { $0 } ) as! T
        }
        let type = "type"
        FatalErrorNotifier.currentNotifier.notify("Could not find a dependency for \(type) \(name).")
        return nil
    }
    
    public static func unload() {
        _dependencies = [:]
        _modules = []
    }
    
    public static var loadedModules: [String] {
        return _modules.map { "\($0.dynamicType)" }
    }
}