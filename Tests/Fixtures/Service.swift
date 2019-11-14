//
//  Service.swift
//  PainlessInjectionTests
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

protocol ServiceProtocol: class {
   
}

class Service: ServiceProtocol {
    static var createdInstances: Int = 0
    
    private(set) var id: Int
    
    init() {
        Service.createdInstances += 1
        id = Service.createdInstances
    }
}
