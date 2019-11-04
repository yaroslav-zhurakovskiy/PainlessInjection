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
        private let arguments: [Any]
        
        init(arguments: [Any]) {
            self.arguments = arguments
        }
        
        var currentValue: Value {
            get {
                if let oldvalue = value {
                    return oldvalue
                } else {
                    value = Container.get(type: Value.self, args: arguments)
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
        self.init(args: [])
    }
    
    public init(_ arguments: Any...) {
        valueHolder = ValueHolder(arguments: arguments)
    }
    public init(args: [Any]) {
        valueHolder = ValueHolder(arguments: args)
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
