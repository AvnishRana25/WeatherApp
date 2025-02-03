import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherData.Current
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 15) {
            // Temperature Display
            Text("\(formatTemperature(weather.temperature2m))°")
                .font(.system(size: 82, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
                .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 2)
            
            // Weather Description with Icon
            HStack(spacing: 10) {
                Image(systemName: getWeatherIcon(weather.weather.main))
                    .font(.title)
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.bounce)
                Text(weather.weather.description.capitalized)
                    .font(.title2)
            }
            .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surface : WeatherColors.Light.surface)
                .shadow(color: Color.primary.opacity(0.15), radius: 15, x: 0, y: 5)
        }
        .overlay {
            // Subtle gradient overlay
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.primary.opacity(0.1),
                            Color.primary.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weather.temperature2m)
        .animation(.easeInOut, value: colorScheme)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.1f", temperature)
    }
}
