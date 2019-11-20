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
}

extension Container {
    public static func load<T: Module>(_ type: T.Type) {
       let module = type.init()
       if module.loadingPredicate().shouldLoadModule() {
         module.load()
       }
       modules.append(module)
    }

    public static func load<T: Module>(_ types: [T.Type]) {
       for type in types {
           load(type)
       }
    }

    public static var loadedModules: [String] {
       return modules.map { "\(type(of: $0))" }
    }
}

func test() {
    Container.load([
        Module.self,
        Module.self,
        Module.self,
        Module.self,
        Module.self,
        Module.self
    ])
}

#if canImport(ObjectiveC)
extension Container {
    public static func load() {
        let loader = ModuleLoader()
        
        let founModules = loader.listOfModules()
        for module in founModules {
            if module.loadingPredicate().shouldLoadModule() {
                module.load()
            }
        }
        modules.append(contentsOf: founModules)
    }
    
    public static func unload() {
        dependencies = [:]
        modules = []
    }
}
#endif

public extension Container {
    static func get<T>(
         type: T.Type,
         args: [Any] = [],
         file: StaticString = #file,
         line: UInt = #line
     ) -> T {
         return get(args: args, file: file, line: line)
     }
     
     static func get<T>(
         _ args: Any...,
         file: StaticString = #file,
         line: UInt = #line
     ) -> T! {
         return get(args: args.map { $0 }, file: file, line: line)
     }
     
     private static func get<T>(
         args: [Any],
         file: StaticString = #file,
         line: UInt = #line
     ) -> T! {
         let name = "\(T.self)"
         guard let dependency = dependencies[name] else {
             FatalErrorNotifier.currentNotifier.notify(
                 "Could not find a dependency for type \(name).",
                 file: file,
                 line: line
             )
             return nil
         }
         
         guard let object = dependency.create(args.map { $0 }) as? T else {
             FatalErrorNotifier.currentNotifier.notify(
                 "Dependency for type \(name) is not \(T.self).",
                 file: file,
                 line: line
             )
             return nil
         }
         
         return object
     }
}
