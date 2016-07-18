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

struct ClousureModuleLoadingPredicate: ModuleLoadingPredicate {
    private var predicate: () -> Bool
    init(_ predicate: () -> Bool) {
        self.predicate = predicate
    }

    func shouldLoadModule() -> Bool {
        return self.predicate()
    }
}

public func clousure(predicate: () -> Bool) -> ModuleLoadingPredicate {
    return ClousureModuleLoadingPredicate(predicate)
}


struct CommandLineArgumentModuleLoadingPredicate: ModuleLoadingPredicate {

    private var _args: [String]
    init(args: [String]) {
        _args = args
    }

    func shouldLoadModule() -> Bool {
        let processArguments = NSProcessInfo.processInfo().arguments
        return Set(_args).isSubsetOf(Set(processArguments))
    }
}

public func commandLineArgs(args: String...) -> ModuleLoadingPredicate {
    return CommandLineArgumentModuleLoadingPredicate(args: args)
}

