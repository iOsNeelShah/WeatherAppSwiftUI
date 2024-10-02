//
//  AppCoordinator.swift
//  WeatherAppSwiftUI
//

import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var currentView: AnyView

    init() {
        let weatherService = WeatherService()
        let locationManager = LocationManager()
        let viewModel = WeatherViewModel(weatherService: weatherService, locationManager: locationManager)
        currentView = AnyView(WeatherScreen(viewModel: viewModel))
    }
}
