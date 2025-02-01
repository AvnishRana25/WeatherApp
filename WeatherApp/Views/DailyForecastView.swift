import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        List {
            if let weather = weatherManager.weatherData {
                ForEach(weather.daily) { day in
                    DailyWeatherCell(daily: day)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 8)
                }
            }
        }
        .listStyle(.plain)
    }
}