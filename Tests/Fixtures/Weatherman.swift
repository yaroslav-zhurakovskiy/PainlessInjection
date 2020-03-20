//
//  Weatherman.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

class Weatherman {
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func say() -> String {
        return "Today`s temperature is \(weatherService.todayTemperature())."
    }
}

class NamedWetherman: Weatherman {
    private let name: String
    
    init(name: String, weatherService: WeatherServiceProtocol) {
        self.name = name
        super.init(weatherService: weatherService)
    }
    
    override func say() -> String {
        return "\(name) says: \(super.say())"
    }
}

class WeathermanClient {
    private let weatherman: Weatherman
    
    init(weatherman: Weatherman) {
        self.weatherman = weatherman
    }
    
    func testSay() -> String {
        return weatherman.say()
    }
}
