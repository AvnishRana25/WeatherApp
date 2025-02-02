import SwiftUI

struct HourlyForecastView: View {
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
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(weather.hourly) { hour in
                            HourlyWeatherCell(hourly: hour)
                                .transition(.scale.combined(with: .slide))
                        }
                    }
                    .padding()
                }
            } else {
                Text("No weather data available")
                    .foregroundColor(.secondary)
            }
        }
    }
}
