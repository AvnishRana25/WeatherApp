//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 03/02/25.

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        Form {
            Section("Units") {
                Toggle("Use Metric", isOn: $settingsManager.isMetric)
                    .animation(.spring(), value: settingsManager.isMetric)
            }
            
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $settingsManager.isDarkMode)
                    .animation(.spring(), value: settingsManager.isDarkMode)
            }
        }
    }
}
