//
//  ArgumentList.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct ArgumentList {
    private let _args: [Any]
    public init(args: [Any]) {
        _args = args
    }
    
    public func at<T>(index: Int, file: StaticString = #file, line: UInt = #line) -> T! {
        if index >= _args.count {
            FatalErrorNotifier.currentNotifier.notify("Expected \(T.self) parameter at index \(index) but got nothing: file \(file), line \(line)")
            return nil
        }
        if let value = _args[index] as? T {
            return value
        }
        FatalErrorNotifier.currentNotifier.notify("Expected \(T.self) parameter at index \(index) but got \(_args[0].dynamicType): file \(file), line \(line)")
        return nil
    }
}
