//
//  Container.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct Container {
    private static var dependencies: [String: Dependency] = [:]
    private static var modules: [Module] = []
    
    internal static func add(_ type: Any.Type, dependency: Dependency) {
        let name = "\(type)"
        if dependencies[name] == nil {
            dependencies[name] = dependency
        }
    }
    
    internal static func setDependency(_ dependency: Dependency, forType type: Any.Type) {
        let name = "\(type)"
        dependencies[name] = dependency
    }
    
    internal static func dependencyForType(_ type: Any.Type) -> Dependency? {
        let name = "\(type)"
        return dependencies[name]
    }
    
    public static func load() {
        let loader = ModuleLoader()
        modules = loader.listOfModules()
            .compactMap { module in
                module.loadingPredicate().shouldLoadModule() ? module : nil
            }
        modules.forEach { module in
            module.load()
        }
    }
    
    public static func get<T>(type: T.Type, args: [Any] = []) -> T {
        return get(args: args)
    }
    
    public static func get<T>(_ args: Any...) -> T! {
        return get(args: args.map { $0 })
    }
    
    public static func get<T, T1>(_ arg1: T1) -> T! {
        return get(args: [arg1])
    }
    
    private static func get<T>(args: [Any]) -> T! {
        let name = "\(T.self)"
        guard let dependency = dependencies[name] else {
            FatalErrorNotifier.currentNotifier.notify("Could not find a dependency for type \(name).")
            return nil
        }
        
        guard let object = dependency.create(args.map { $0 }) as? T else {
            FatalErrorNotifier.currentNotifier.notify("Dependency for type \(name) is not \(T.self).")
            return nil
        }
        
        return object
    }
    
    public static func unload() {
        dependencies = [:]
        modules = []
    }
    
    public static var loadedModules: [String] {
        return modules.map { "\(type(of: $0))" }
    }
}
