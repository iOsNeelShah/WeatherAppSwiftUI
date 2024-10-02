//
//  Weather.swift
//  WeatherAppSwiftUI
//

import Foundation

struct Weather: Codable {
    let main: Main
    let name: String
    let weather: [WeatherCondition]
    
    struct Main: Codable {
        let temp: Double
        
        func getTemp() -> String {
            return String(format: "%.2f", temp)
        }
    }
    
    struct WeatherCondition: Codable {
        let description: String
        let icon: String
    }
}
