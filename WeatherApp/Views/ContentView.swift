//
//  ContentView.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager
    
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
        }
    }
}

