import SwiftUI

struct WeatherDetailsGrid: View {
    @EnvironmentObject var settingsManager: SettingsManager
    let weather: WeatherData.Current 
    
    var body: some View  {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
            WeatherInfoItem(title: "Humidity",
                          value: "\(weather.relativeHumidity2m)%",
                          icon: "humidity.fill")
            
            WeatherInfoItem(title: "Wind Speed",
                          value: formatWindSpeed(weather.windSpeed10m),
                          icon: "wind")
            
            WeatherInfoItem(title: "UV Index",
                          value: String(format: "%.1f", weather.uvIndex),
                          icon: "sun.max.fill")
            
            WeatherInfoItem(title: "Visibility",
                          value: formatVisibility(weather.visibility),
                          icon: "eye.fill")
            
            WeatherInfoItem(title: "Pressure",
                          value: "\(Int(weather.pressureMsl)) hPa",
                          icon: "gauge")
            
            WeatherInfoItem(title: "Cloud Cover",
                          value: "\(weather.cloudCover)%",
                          icon: "cloud.fill")
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather)
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
