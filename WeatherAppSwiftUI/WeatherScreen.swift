//
//  ContentView.swift
//  WeatherAppSwiftUI
//

import SwiftUI

struct WeatherScreen: View {
    @StateObject private var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $viewModel.city, onCommit: {
                viewModel.fetchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top, 40) // padding from the top
            .foregroundColor(viewModel.isValidCity ? .primary : .red) // Change text color based on validity
            .onChange(of: viewModel.city) {
                viewModel.validateCity() // Validate whenever the text changes
            }
            
            Button("Get Weather") {
                viewModel.fetchWeather()
            }
            .padding()
            .disabled(!viewModel.isValidCity) // Disable the button if the city is invalid
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
                    .padding()
            }
            
            if let weather = viewModel.weather {
                Text("Temperature: \(weather.main.getTemp())°F")
                Text("Condition: \(weather.weather.first?.description ?? "")")
                if let iconCode = weather.weather.first?.icon {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            Spacer() // This pushes the content to the top
        }
        .navigationTitle("Weather App")
        .padding()
        .onAppear {
            // Fetch weather using location if available
            if viewModel.locationManager.currentLocation != nil {
                viewModel.fetchWeatherByLocation(location: viewModel.locationManager.currentLocation!)
            } else {
                viewModel.fetchWeather()
            }
        }
    }
}
