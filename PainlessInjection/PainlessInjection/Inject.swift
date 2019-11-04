//
//  Inject.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 04.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

#if swift(>=5.1)

@propertyWrapper
public struct Inject<Value> {
    private var value: Value?
    
    public init() {
        
    }
    
    public var wrappedValue: Value {
        mutating get {
            if let oldvalue = value {
                return oldvalue
            } else {
                value = Container.get(Value.self)
                return value!
            }
        }
        set {
            value = newValue
        }
    }
}

#endif
