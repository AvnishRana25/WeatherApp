import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        NavigationView {
            Group {
                if weatherManager.isLoading && weatherManager.weatherData == nil {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = weatherManager.error as? AppError {
                    ErrorView(error: error) {
                        Task {
                            await weatherManager.refreshWeather()
                        }
                    }
                } else if let weather = weatherManager.weatherData {
                    HourlyPreviewView(hourlyData: weather.hourly.forecasts)
                        .padding()
                } else {
                    Text("No weather data available")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Hourly Forecast")
        }
    }
}
