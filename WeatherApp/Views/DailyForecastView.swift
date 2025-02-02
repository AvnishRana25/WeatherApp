import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        Group {
            if weatherManager.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let error = weatherManager.error as? AppError {
                ErrorView(error: error) {
                    Task {
                        await weatherManager.refreshWeather()
                    }
                }
            } else if let weather = weatherManager.weatherData {
                List {
                    ForEach(weather.daily) { day in
                        DailyWeatherCell(daily: day)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
            } else {
                Text("No weather data available")
                    .foregroundColor(.secondary)
            }
        }
    }
}
