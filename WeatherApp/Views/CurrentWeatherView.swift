import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if weatherManager.isLoading && weatherManager.weatherData == nil {
                    LoadingView()
                } else if let error = weatherManager.error as? AppError {
                    ErrorView(error: error) {
                        Task { await weatherManager.refreshWeather() }
                    }
                } else if let weather = weatherManager.weatherData {
                    VStack(spacing: 25) {
                        // Location and Current Weather
                        VStack(spacing: 15) {
                            // Location Header
                            VStack(spacing: 4) {
                                HStack {
                                    Spacer()
                                    Text(weatherManager.locationName ?? "Current Location")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.75)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color(.systemBackground).opacity(0.5))
                            .cornerRadius(10)
                            
                            WeatherHeaderView(weather: weather.current)
                                .transition(.moveAndFade)
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.primary.opacity(0.3), radius: 10, x: 0, y: 2)
                        
                        // Weather Details Grid
                        WeatherDetailsGrid(weather: weather.current)
                            .transition(.scale)
                            .padding(.horizontal)
                        
                        // Hourly Forecast
                        if !weather.hourly.forecasts.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Today's Forecast")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                HourlyPreviewView(hourlyData: Array(weather.hourly.forecasts.prefix(24)))
                                    .transition(.slide)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.primary.opacity(0.1), radius: 10)
                        }
                    }
                    .padding()
                    .overlay {
                        if weatherManager.isLoading {
                            LoadingOverlay()
                        }
                    }
                } else {
                    EmptyStateView()
                }
            }
            .background(Color(.systemBackground))
            .refreshable {
                isRefreshing = true
                await weatherManager.refreshWeather()
                isRefreshing = false
            }
            .navigationTitle("Weather")
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weatherManager.weatherData)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.accentColor)
            Text("Loading weather data...")
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.8)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.accentColor)
        }
        .background(.ultraThinMaterial)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("No weather data available")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 100)
    }
}
