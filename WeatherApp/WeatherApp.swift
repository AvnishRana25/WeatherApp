//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var weatherManager = WeatherManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsManager)
                .environmentObject(weatherManager)
        }
    }
}

