import SwiftUI

struct HourlyWeatherCell: View {
    let hourly: WeatherData.HourlyForecast
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 8) {
            Text(formatHour(hourly.time))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Image(systemName: getWeatherIcon(hourly.weather.main, isDay: hourly.isDay == 1))
                .font(.title2)
                .symbolEffect(.bounce)
            
            Text("\(formatTemperature(hourly.temp))°")
                .font(.headline)
            
            if hourly.precipitationProbability > 0 {
                Text("\(hourly.precipitationProbability)%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 70)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
        .animation(.spring(response: 0.3), value: hourly.temp)
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
}
