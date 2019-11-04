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
    private class ValueHolder {
        private var value: Value?
        
        var currentValue: Value {
            get {
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
    private let valueHolder: ValueHolder
    
    public init() {
        valueHolder = ValueHolder()
    }
    
    public var wrappedValue: Value {
        get {
            return valueHolder.currentValue
        }
        set {
            valueHolder.currentValue = newValue
        }
    }
}

#endif
