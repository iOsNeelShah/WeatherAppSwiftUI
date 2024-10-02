//
//  MockWeatherAppService.swift
//  WeatherAppSwiftUITests
//

import CoreLocation
import Foundation
@testable import WeatherAppSwiftUI

class MockWeatherService: WeatherServiceProtocol {
    
    var weatherResponse: Weather?
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        if let weather = weatherResponse {
            completion(.success(weather))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])))
        }
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
        if let weather = weatherResponse {
            completion(.success(weather))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])))
        }
    }
}
