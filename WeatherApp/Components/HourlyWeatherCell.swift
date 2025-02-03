import SwiftUI

struct HourlyWeatherCell: View {
    let hourly: WeatherData.HourlyForecast
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Text(formatHour(hourly.time))
                .font(.caption)
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
            
            ZStack {
                Circle()
                    .fill(getWeatherColor(hourly.weather.main).opacity(colorScheme == .dark ? 0.2 : 0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: getWeatherIcon(hourly.weather.main, isDay: hourly.isDay == 1))
                    .font(.title3)
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.bounce)
            }
            
            Text("\(formatTemperature(hourly.temp))°")
                .font(.system(.headline, design: .rounded, weight: .semibold))
            
            if hourly.precipitationProbability > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                    Text("\(hourly.precipitationProbability)%")
                }
                .font(.caption2)
                .foregroundStyle(.blue)
            }
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surfaceSecondary : WeatherColors.Light.surfaceSecondary)
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        }
    }
    
    private func formatHour(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        guard let date = formatter.date(from: timeString) else {
            print("Error formatting hour: \(timeString)")
            return "--:--"
        }
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatTemperature(_ temp: Double) -> String {
        let temperature = settingsManager.isMetric ? temp : (temp * 9/5 + 32)
        return String(format: "%.0f", temperature)
    }
    
    private func getWeatherIcon(_ condition: String, isDay: Bool) -> String {
        switch condition.lowercased() {
        case "clear":
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case "clouds":
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case "rain":
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "fog":
            return "cloud.fog.fill"
        default:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        }
    }
    
    private func getWeatherColor(_ condition: String) -> Color {
        switch condition.lowercased() {
        case "clear": return .orange
        case "clouds": return .gray
        case "rain": return .blue
        case "snow": return .cyan
        case "thunderstorm": return .purple
        default: return .gray
        }
    }
}

