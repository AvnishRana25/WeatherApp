import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView {
            if let error = weatherManager.error as? AppError {
                ErrorView(error: error) {
                    Task {
                        await weatherManager.refreshWeather()
                    }
                }
                .padding()
            } else if let weather = weatherManager.weatherData {
                VStack(spacing: 20) {
                    WeatherHeaderView(weather: weather.current)
                        .transition(.moveAndFade)
                    
                    WeatherDetailsGrid(weather: weather.current) // Remove 'settingsManager' parameter
                    
                    HourlyPreviewView(hourlyData: Array(weather.hourly.prefix(6)))
                        .transition(.slide)
                }
                .padding()
            } else {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .refreshable {
            isRefreshing = true
            await weatherManager.refreshWeather()
            isRefreshing = false
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weatherManager.weatherData) // Remove default value
    }
}
