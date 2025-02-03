import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherData.Current
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(formatTemperature(weather.temperature2m))°")
                .font(.system(size: 72, weight: .bold))
            
            Text(weather.weather.description.capitalized)
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(15)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather.temperature2m)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.1f", temperature)
    }
}
