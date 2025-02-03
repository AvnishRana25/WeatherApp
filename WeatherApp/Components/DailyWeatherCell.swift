import SwiftUI

struct DailyWeatherCell: View {
    let daily: WeatherData.DailyForecast
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Day and Weather Info
            VStack(alignment: .leading, spacing: 6) {
                Text(formatDay(daily.time))
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
                
                Text(daily.weather.description.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
                
                if daily.precipitationProbability > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .foregroundStyle(.blue)
                        Text("\(daily.precipitationProbability)%")
                            .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
                    }
                    .font(.caption)
                }
            }
            
            Spacer()
            
            // Weather Icon
            ZStack {
                Circle()
                    .fill(getWeatherColor(daily.weather.main).opacity(colorScheme == .dark ? 0.2 : 0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: getWeatherIcon(daily.weather.main))
                    .font(.title2)
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.bounce)
            }
            
            // Temperature Range
            HStack(spacing: 12) {
                Text("\(formatTemperature(daily.tempMax))°")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
                
                Text("\(formatTemperature(daily.tempMin))°")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
            }
            .frame(width: 100)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surfaceSecondary : WeatherColors.Light.surfaceSecondary)
                .shadow(
                    color: (colorScheme == .dark ? WeatherColors.Dark.shadow : WeatherColors.Light.shadow)
                        .opacity(isHovered ? 0.15 : 0.1),
                    radius: isHovered ? 8 : 5,
                    x: 0,
                    y: isHovered ? 4 : 2
                )
        }
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func formatDay(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: timeString) else { return "" }
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.0f", temperature)
    }
    
    private func getWeatherIcon(_ condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain":
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "fog":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }
    
    private func getWeatherColor(_ condition: String) -> Color {
        switch condition.lowercased() {
        case "clear": return .orange
        case "clouds": return colorScheme == .dark ? .gray : Color(.systemGray1)
        case "rain": return .blue
        case "snow": return .cyan
        case "thunderstorm": return .purple
        default: return colorScheme == .dark ? .gray : Color(.systemGray1)
        }
    }
}

// Add custom transitions extension
extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

