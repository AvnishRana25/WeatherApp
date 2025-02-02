import SwiftUI

struct HourlyPreviewView: View {
    let hourlyData: [WeatherData.HourlyForecast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.bottom, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(hourlyData) { hour in
                        HourlyWeatherCell(hourly: hour)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .padding(.vertical)
    }
} 