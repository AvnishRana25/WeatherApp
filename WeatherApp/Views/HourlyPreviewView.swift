import SwiftUI

struct HourlyPreviewView: View {
    let hourlyData: [WeatherData.Hourly]
    
    var body: some View {
        HStack {
            ForEach(hourlyData) { hour in
                HourlyWeatherCell(hourly: hour)
            }
        }
    }
} 