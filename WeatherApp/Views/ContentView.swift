//
//  ContentView.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        NavigationStack {
            TabView {
                CurrentWeatherView()
                    .tabItem {
                        Label("Current", systemImage: "sun.max.fill")
                    }
                
                HourlyForecastView()
                    .tabItem {
                        Label("Hourly", systemImage: "clock")
                    }
                
                DailyForecastView()
                    .tabItem {
                        Label("Daily", systemImage: "calendar")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .task {
                // Initial weather fetch with retry
                await fetchWeatherWithRetry()
            }
            .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
        .environmentObject(locationManager)
    }
    
    private func fetchWeatherWithRetry() async {
        for attempt in 1...3 {
            await weatherManager.refreshWeather()
            if weatherManager.weatherData != nil {
                break
            }
            if attempt < 3 {
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 second delay
            }
        }
    }
}

