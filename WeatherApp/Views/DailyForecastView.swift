//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 03/02/25.

import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            Group {
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
                } else if let weather = weatherManager.weatherData {
                    List {
                        Section {
                            ForEach(weather.daily.forecasts) { day in
                                DailyWeatherCell(daily: day)
                                    .listRowInsets(EdgeInsets())
                                    .padding(.vertical, 8)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                    }
                            }
                        } header: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("7-Day Forecast")
                                    .font(.headline)
                                    .textCase(nil)
                                    .foregroundColor(.primary)
                                
                                Text("Updated \(formatUpdateTime(weather.current.time))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        isRefreshing = true
                        await weatherManager.refreshWeather()
                        isRefreshing = false
                    }
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
                }
            }
            .navigationTitle("Daily Forecast")
        }
    }
    
    private func formatUpdateTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        guard let date = formatter.date(from: timeString) else {
            print("Error formatting date: \(timeString)")
            return "Recently Updated"
        }
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
