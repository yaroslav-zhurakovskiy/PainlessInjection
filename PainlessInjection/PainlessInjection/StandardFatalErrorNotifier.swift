//
//  StandardFatalErrorNotifier.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

open class StandardFatalErrorNotifier: FatalErrorNotifierProtocol {
    open func notify(_ message: String) {
        assertionFailure(message)
    }
}
