//
//  ModuleLoader.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/18/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class ModuleLoader {
    
    func listOfModules() -> [Module] {
        var result: [Module] = []

        let numberOfClasses = objc_getClassList(nil, 0)
        if numberOfClasses > 0 {
            let classesStorage = UnsafeMutablePointer<AnyClass?>.alloc(Int(numberOfClasses))
            defer {
                classesStorage.dealloc(Int(numberOfClasses))
            }
            let classes = AutoreleasingUnsafeMutablePointer<AnyClass?>(classesStorage)
            objc_getClassList(classes, numberOfClasses)
            for index in 0..<Int(numberOfClasses) {
                if let cls: AnyClass = classes[index] {
                    if class_getSuperclass(cls) != Module.self { continue }
                    if  let moduleClass = cls as? Module.Type {
                        let module: Module = moduleClass.init()
                        result.append(module)
                    }
                }
            }
        }
        
        return result
    }
    
}