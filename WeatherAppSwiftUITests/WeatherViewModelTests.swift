//
//  WeatherViewModelTests.swift
//  WeatherAppSwiftUITests
//


import Combine
import CoreLocation
@testable import WeatherAppSwiftUI
import XCTest


class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        let locationManager = LocationManager()
        viewModel = WeatherViewModel(weatherService: mockService, locationManager: locationManager)
        cancellables = []
    }
    
    func test_FetchWeatherSuccess() {
        let expectation = XCTestExpectation(description: "Weather fetched successfully")
        
        mockService.weatherResponse = Weather(main: Weather.Main(temp: 12.0), name: "City", weather: [])
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                XCTAssertNotNil(weather)
                XCTAssertEqual(weather!.main.temp, 12.0)
                XCTAssertEqual(weather!.name, "City")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchWeather()
        
        wait(for: [expectation])
    }
    
    func test_FetchWeatherFailure() {
        let expectation = XCTestExpectation(description: "Weather fetched failure")
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather()
        wait(for: [expectation])
    }
    
    func test_FetchWeatherByLocation() {
        let locationManager = LocationManager()
        viewModel = WeatherViewModel(weatherService: mockService, locationManager: locationManager)
        
        let expectation = XCTestExpectation(description: "Weather fetched location successfully")
        mockService.weatherResponse = Weather(main: Weather.Main(temp: 12.0), name: "City", weather: [])
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                XCTAssertNotNil(weather)
                XCTAssertEqual(weather?.main.temp, 12.0)
                XCTAssertEqual(weather?.name, "City")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let location: CLLocation = CLLocation(latitude: latitude,
                                              longitude: longitude)
        
        locationManager.currentLocation = location
        
        wait(for: [expectation])
    }
    
    func test_FetchWeatherByLocationFailure() {
        let expectation = XCTestExpectation(description: "Weather fetched location failure")
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let location: CLLocation = CLLocation(latitude: latitude,
                                              longitude: longitude)
        
        viewModel.fetchWeatherByLocation(location: location)
        wait(for: [expectation])
    }
    
    func test_validCityWithFetch() {
        viewModel.isValidCity = false
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
            }
            .store(in: &cancellables)
        viewModel.fetchWeather()
    }
    
    func test_validCitySuccess() {
        viewModel.city = "NJ"
        viewModel.validateCity()
        XCTAssertTrue(viewModel.isValidCity)
    }
}
