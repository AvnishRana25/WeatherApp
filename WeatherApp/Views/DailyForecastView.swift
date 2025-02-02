import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
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
                        ForEach(weather.daily.forecasts) { day in
                            DailyWeatherCell(daily: day)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 8)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        isRefreshing = true
                        await weatherManager.refreshWeather()
                        isRefreshing = false
                    }
                } else {
                    Text("No weather data available")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Daily Forecast")
        }
    }
}
