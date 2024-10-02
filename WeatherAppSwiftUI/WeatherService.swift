//
//  WeatherService.swift
//  WeatherAppSwiftUI
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void)
    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<Weather, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "534cbcd725433e2485685336e141c634"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void ) {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=imperial"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
