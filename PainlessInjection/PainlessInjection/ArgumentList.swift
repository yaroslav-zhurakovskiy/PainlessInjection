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
        if index >= _args.count {
            FatalErrorNotifier.currentNotifier.notify("Expected \(T.self) parameter at index \(index) but got nothing: file \(file), line \(line)")
            return nil
        }
        if let value = _args[index] as? T {
            return value
        }
        FatalErrorNotifier.currentNotifier.notify("Expected \(T.self) parameter at index \(index) but got \(type(of: _args[0])): file \(file), line \(line)")
        return nil
    }
}
