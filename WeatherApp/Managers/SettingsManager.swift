import Foundation

class SettingsManager: ObservableObject {
    @Published var isMetric = true
    @Published var isDarkMode = false
    
    init() {
        isMetric = UserDefaults.standard.bool(forKey: "isMetric")
        isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
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