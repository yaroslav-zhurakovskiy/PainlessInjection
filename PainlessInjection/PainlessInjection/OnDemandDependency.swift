//
//  OnDemandDependency.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/18/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class OnDemandDependency: Dependency {
    
    private var _type: Any.Type
    var type: Any.Type {
        return _type
    }
    
    private var _configurator: ([Any]) -> Any
    init(type: Any.Type,  configurator: ([Any]) -> Any) {
        _type = type
        _configurator = configurator
    }
    
    func create(args: [Any]) -> Any {
        return _configurator(args)
    }
    
}