import SwiftUI

struct HourlyPreviewView: View {
    let hourlyData: [WeatherData.HourlyForecast]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.bottom, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(hourlyData.prefix(24)) { hour in
                        HourlyWeatherCell(hourly: hour)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.vertical)
        .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.7))
        .cornerRadius(12)
    }
} 