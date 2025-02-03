import SwiftUI

struct WeatherDetailsGrid: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    let weather: WeatherData.Current 
    
    var body: some View  {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
            WeatherInfoItem(title: "Humidity",
                          value: "\(weather.relativeHumidity2m)%",
                          icon: "humidity.fill",
                          tint: .blue)
            
            WeatherInfoItem(title: "Wind Speed",
                          value: formatWindSpeed(weather.windSpeed10m),
                          icon: "wind",
                          tint: .green)
            
            WeatherInfoItem(title: "UV Index",
                          value: String(format: "%.1f", weather.uvIndex),
                          icon: "sun.max.fill",
                          tint: .orange)
            
            WeatherInfoItem(title: "Visibility",
                          value: formatVisibility(weather.visibility),
                          icon: "eye.fill",
                          tint: .purple)
            
            WeatherInfoItem(title: "Pressure",
                          value: "\(Int(weather.pressureMsl)) hPa",
                          icon: "gauge",
                          tint: .red)
            
            WeatherInfoItem(title: "Cloud Cover",
                          value: "\(weather.cloudCover)%",
                          icon: "cloud.fill",
                          tint: .gray)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather)
        .animation(.easeInOut, value: colorScheme)
    }
    
    private func formatWindSpeed(_ speed: Double) -> String {
        let windSpeed = settingsManager.isMetric ? speed : (speed * 2.237)
        let unit = settingsManager.isMetric ? "m/s" : "mph"
        return String(format: "%.1f %@", windSpeed, unit)
    }
    
    private func formatVisibility(_ visibility: Int) -> String {
        let distance = settingsManager.isMetric ? Double(visibility) / 1000 : Double(visibility) / 1609.34
        let unit = settingsManager.isMetric ? "km" : "mi"
        return String(format: "%.1f %@", distance, unit)
    }
}
