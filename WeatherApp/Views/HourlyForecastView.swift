import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                if let weather = weatherManager.weatherData {
                    ForEach(weather.hourly) { hour in
                        HourlyWeatherCell(hourly: hour)
                            .transition(.scale.combined(with: .slide))
                    }
                }
            }
            .padding()
        }
    }
}