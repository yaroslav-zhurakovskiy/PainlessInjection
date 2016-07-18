//
//  StandardFatalErrorNotifier.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

public class StandardFatalErrorNotifier: FatalErrorNotifierProtocol {
    public func notify(message: String) {
        assertionFailure(message)
    }
}