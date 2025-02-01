//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationManager())
                .environmentObject(WeatherManager())
                .environmentObject(SettingsManager())
        }
    }
}

