import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherData.Current
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(formatTemperature(weather.temperature2m))°")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
            
            Text(weather.weather.description.capitalized)
                .font(.title2)
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surface : WeatherColors.Light.surface)
                .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 4)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather.temperature2m)
        .animation(.easeInOut, value: colorScheme)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.1f", temperature)
    }
}
