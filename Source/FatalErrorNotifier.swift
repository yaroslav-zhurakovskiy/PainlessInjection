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
    private static var currentNotifierVar: FatalErrorNotifierProtocol?
    
    public static var currentNotifier: FatalErrorNotifierProtocol {
        get {
            if let current = currentNotifierVar {
                return current
            }
            return StandardFatalErrorNotifier()
        } set {
            currentNotifierVar = newValue
        }
    }
    
    public static func reset() {
        currentNotifierVar = nil
    }
}
