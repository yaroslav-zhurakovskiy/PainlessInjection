//
//  WeatherService.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation

protocol WeatherServiceProtocol {
    func todayTemperature() -> Double
}

class WeatherServce: WeatherServiceProtocol {
    public static let defaultValue = 36.6
    
    let temperature: Double
    
    init(temperature: Double = defaultValue) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature
    }
}

class OptionalWeatherService: WeatherServiceProtocol {
    static let defaultValue: Double = -1.0
    
    let temperature: Double?
    
    init(temperature: Double?) {
        self.temperature = temperature
    }
    
    func todayTemperature() -> Double {
        return temperature ?? Self.defaultValue
    }
}
