import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherData.Current
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(formatTemperature(weather.temp))°")
                .font(.system(size: 72, weight: .bold))
                .symbolEffect(.bounce)
            
            Text("Feels like \(formatTemperature(weather.feelsLike))°")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.title2)
                .symbolEffect(.bounce)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(15)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather.temp)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.1f", temperature)
    }
}
