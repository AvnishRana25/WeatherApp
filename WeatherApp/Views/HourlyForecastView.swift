//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 03/02/25.

import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                if weatherManager.isLoading && weatherManager.weatherData == nil {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if let error = weatherManager.error as? AppError {
                    ErrorView(error: error) {
                        Task {
                            await weatherManager.refreshWeather()
                        }
                    }
                } else if let weather = weatherManager.weatherData {
                    LazyVStack(spacing: 16) {
                        ForEach(weather.hourly.forecasts) { hour in
                            HourlyWeatherCell(hourly: hour)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                } else {
                    Text("No weather data available")
                        .foregroundColor(.secondary)
                }
            }
            .refreshable {
                await weatherManager.refreshWeather()
            }
            .navigationTitle("Hourly Forecast")
        }
    }
}
