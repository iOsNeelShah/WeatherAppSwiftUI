//
//  WeatherViewModel.swift
//  WeatherAppSwiftUI
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var city: String = UserDefaults.standard.string(forKey: "lastSearchedCity") ?? "San Francisco"
    @Published var errorMessage: String?
    @Published var isValidCity: Bool = true // To track the validity of the city input
    private var weatherService: WeatherServiceProtocol
    var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherServiceProtocol, locationManager: LocationManager) {
        self.weatherService = weatherService
        self.locationManager = locationManager
        
        // Observe location changes
        locationManager.$currentLocation
            .sink { [weak self] location in
                if let location = location {
                    self?.fetchWeatherByLocation(location: location)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchWeather() {
        guard isValidCity else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter a valid city."
            }
            return
        }
        
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weather = weather
                    UserDefaults.standard.set(self.city, forKey: "lastSearchedCity")
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchWeatherByLocation(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        weatherService.fetchWeatherByCoordinates(lat: lat, lon: lon) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weather = weather
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func validateCity() {
        // Check if the city string is non-empty and contains only letters
        isValidCity = !city.trimmingCharacters(in: .whitespaces).isEmpty && city.allSatisfy { $0.isLetter }
    }
}
