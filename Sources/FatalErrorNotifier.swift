//
//  FatalErrorNotifier.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public protocol FatalErrorNotifierProtocol {
    func notify(_ message: String)
}

public struct FatalErrorNotifier {
    
    fileprivate static var _currentNotifier: FatalErrorNotifierProtocol?
    public static var currentNotifier: FatalErrorNotifierProtocol {
        get {
            if let current = _currentNotifier {
                return current
            }
            return StandardFatalErrorNotifier()
        } set {
            _currentNotifier = newValue
        }
    }
    
    public static func reset() {
        _currentNotifier = nil
    }
}
