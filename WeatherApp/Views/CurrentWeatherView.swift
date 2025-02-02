import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if weatherManager.isLoading && weatherManager.weatherData == nil {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if let error = weatherManager.error as? AppError {
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
                        
                        WeatherDetailsGrid(weather: weather.current)
                            .transition(.scale)
                        
                        if !weather.hourly.forecasts.isEmpty {
                            HourlyPreviewView(hourlyData: Array(weather.hourly.forecasts.prefix(24)))
                                .transition(.slide)
                        }
                    }
                    .padding()
                    .overlay {
                        if weatherManager.isLoading {
                            ZStack {
                                Color.black.opacity(0.1)
                                    .ignoresSafeArea()
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                        }
                    }
                } else {
                    Text("No weather data available")
                        .foregroundColor(.secondary)
                        .padding(.top, 100)
                }
            }
            .refreshable {
                isRefreshing = true
                await weatherManager.refreshWeather()
                isRefreshing = false
            }
            .navigationTitle("Current Weather")
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weatherManager.weatherData)
        }
    }
}
