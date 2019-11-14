//
//  ArgumentList.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public struct ArgumentList {
    private let args: [Any]
    
    public init(args: [Any]) {
        self.args = args
    }
    
    public func at<T>(_ index: Int, file: StaticString = #file, line: UInt = #line) -> T! {
        guard index < args.count else {
            let msg =
                "Expected \(T.self) parameter" +
                " at index \(index)" +
                " but got nothing: file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg, file: file, line: line)
            return nil
        }
        
        guard let value = args[index] as? T else {
            let msg =
                "Expected \(T.self) parameter" +
                " at index \(index)" +
                " but got \(type(of: args[0])): file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg, file: file, line: line)
            return nil
        }
        
        return value
    }
    
    public func optionalAt<T>(_ index: Int, file: StaticString = #file, line: UInt = #line) -> T? {
        guard index < args.count else {
            let msg =
                "Expected \(T.self) parameter" +
                " at index \(index)" +
                " but got nothing: file \(file), line \(line)"
            FatalErrorNotifier.currentNotifier.notify(msg, file: file, line: line)
            return nil
        }
        
        return args[index] as? T
    }
}
