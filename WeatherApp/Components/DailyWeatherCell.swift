import SwiftUI

struct DailyWeatherCell: View {
    let daily: WeatherData.DailyForecast
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formatDay(daily.time))
                    .font(.headline)
                
                Text(daily.weather.description.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if daily.precipitationProbability > 0 {
                    Text("\(daily.precipitationProbability)% chance of precipitation")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: getWeatherIcon(daily.weather.main))
                .font(.title2)
                .symbolEffect(.bounce)
                .frame(width: 50)
            
            HStack(spacing: 16) {
                Text("\(formatTemperature(daily.tempMax))°")
                    .font(.headline)
                
                Text("\(formatTemperature(daily.tempMin))°")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 100)
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .hoverEffect()
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
        default:
            return "cloud.fill"
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

