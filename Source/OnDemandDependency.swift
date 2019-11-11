//
//  OnDemandDependency.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/18/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class OnDemandDependency: Dependency {
    let type: Any.Type
    let configurator: ([Any]) -> Any
    
    init(type: Any.Type, configurator: @escaping ([Any]) -> Any) {
        self.type = type
        self.configurator = configurator
    }
     
    func create(_ args: [Any]) -> Any {
        return configurator(args)
    }
}
