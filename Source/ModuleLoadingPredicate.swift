//
//  ModuleLoadingPredicate.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/12/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public protocol ModuleLoadingPredicate {
    func shouldLoadModule() -> Bool
}

struct LoadModulePredicate: ModuleLoadingPredicate {
    func shouldLoadModule() -> Bool {
        return true
    }
}
