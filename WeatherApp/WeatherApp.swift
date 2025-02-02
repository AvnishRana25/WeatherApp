//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherManager)
                .environmentObject(settingsManager)
        }
    }
}

