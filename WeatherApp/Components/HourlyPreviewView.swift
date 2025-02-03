//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.

import SwiftUI

struct HourlyPreviewView: View {
    let hourlyData: [WeatherData.HourlyForecast]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock")
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
                Text("Hourly Forecast")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(hourlyData.prefix(24)) { hour in
                        HourlyWeatherCell(hourly: hour)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surface : WeatherColors.Light.surface)
                .shadow(color: colorScheme == .dark ? WeatherColors.Dark.shadow : WeatherColors.Light.shadow,
                       radius: 10, x: 0, y: 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            colorScheme == .dark ? WeatherColors.Dark.gradient1 : WeatherColors.Light.gradient1,
                            colorScheme == .dark ? WeatherColors.Dark.gradient2 : WeatherColors.Light.gradient2
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
} 
