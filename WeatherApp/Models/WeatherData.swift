import Foundation

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    struct Current: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        let windSpeed: Double
        let pressure: Int
        let uvIndex: Double
        let visibility: Int
        let dewPoint: Double
        let clouds: Int
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
            case windSpeed = "wind_speed"
            case pressure
            case uvIndex = "uvi"
            case visibility
            case dewPoint = "dew_point"
            case clouds
            case weather
        }
    }
    
    struct Hourly: Codable, Identifiable {
        let id = UUID()
        let dt: Int
        let temp: Double
        let weather: [Weather]
    }
    
    struct Daily: Codable, Identifiable {
        let id = UUID()
        let dt: Int
        let temp: DailyTemp
        let weather: [Weather]
    }
    
    struct DailyTemp: Codable {
        let min: Double
        let max: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
