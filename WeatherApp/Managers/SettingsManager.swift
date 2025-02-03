//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.

import Foundation

class SettingsManager: ObservableObject {
    @Published var isMetric = true
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        isMetric = UserDefaults.standard.bool(forKey: "isMetric")
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleUnit() {
        isMetric.toggle()
        UserDefaults.standard.set(isMetric, forKey: "isMetric")
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
}
