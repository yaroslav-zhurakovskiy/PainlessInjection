//
//  ArgumentList.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct ArgumentList {
    fileprivate let _args: [Any]
    
    public init(args: [Any]) {
        _args = args
    }
    
    public func at<T>(_ index: Int, file: StaticString = #file, line: UInt = #line) -> T! {
        guard index < _args.count else {
            let msg = "Expected \(T.self) parameter at index \(index) but got nothing: file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg)
            return nil
        }
        
        guard let value = _args[index] as? T else {
            let msg = "Expected \(T.self) parameter at index \(index) but got \(type(of: _args[0])): file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg)
            return nil
        }
        
        return value
    }
    
    public func optionalAt<T>(_ index: Int, file: StaticString = #file, line: UInt = #line) -> T? {
        guard index < _args.count else {
            let msg = "Expected \(T.self) parameter at index \(index) but got nothing: file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg)
            return nil
        }
        
        return _args[index] as? T
    }
}