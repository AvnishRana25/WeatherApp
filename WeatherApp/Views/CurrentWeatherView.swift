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
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.75)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            
                            WeatherHeaderView(weather: weather.current)
                                .transition(.moveAndFade)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        
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
                                    .foregroundColor(Color.secondary)
                                    .padding(.horizontal)
                                
                                HourlyPreviewView(hourlyData: Array(weather.hourly.forecasts.prefix(24)))
                                    .transition(.slide)
                            }
                            .padding()
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: ColorTheme.primary.opacity(0.1), radius: 10)
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
            .background(ColorTheme.background)
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
                .tint(ColorTheme.primary)
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
            ColorTheme.background.opacity(0.8)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.5)
                .tint(ColorTheme.primary)
        }
        .background(.ultraThinMaterial)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 50))
                .foregroundColor(Color.secondary)
            Text("No weather data available")
                .font(.headline)
                .foregroundColor(Color.secondary)
        }
        .padding(.top, 100)
    }
}
