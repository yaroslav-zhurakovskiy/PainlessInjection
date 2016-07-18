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