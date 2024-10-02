//
//  WeatherAppSwiftUIApp.swift
//  WeatherAppSwiftUI
//

import SwiftUI

@main
struct WeatherAppSwiftUIApp: App {
    @StateObject var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.currentView
        }
    }
}
