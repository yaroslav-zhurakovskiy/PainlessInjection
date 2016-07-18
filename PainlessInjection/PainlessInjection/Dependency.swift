//
//  Dependency.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public protocol Dependency {
    var type: Any.Type { get }
    func create(args: [Any]) -> Any
}

public class OnDemandDependency: Dependency {
    
    private var _type: Any.Type
    public var type: Any.Type {
        return _type
    }
    
    private var _configurator: ([Any]) -> Any
    public init(type: Any.Type,  configurator: ([Any]) -> Any) {
        _type = type
        _configurator = configurator
    }
    
    public func create(args: [Any]) -> Any {
        return _configurator(args)
    }

}