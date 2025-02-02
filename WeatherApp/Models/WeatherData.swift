import Foundation

struct WeatherData: Decodable, Equatable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    // MARK: - Current Weather
    struct Current: Codable, Equatable {
        let dt: Int
        let sunrise: Int?
        let sunset: Int?
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        let dewPoint: Double?
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let windSpeed: Double
        let windDeg: Int?
        let weather: [Weather]
    }
    
    // MARK: - Hourly Forecast
    struct Hourly: Codable, Equatable, Identifiable {
        let dt: Int
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        let dewPoint: Double?
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let windSpeed: Double
        let windDeg: Int?
        let weather: [Weather]
        let pop: Double?
        
        var id: Int { dt }
    }
    
    // MARK: - Daily Forecast
    struct Daily: Codable, Equatable, Identifiable {
        let dt: Int
        let sunrise: Int?
        let sunset: Int?
        let temp: Temp
        let feelsLike: FeelsLike?
        let pressure: Int
        let humidity: Int
        let dewPoint: Double?
        let windSpeed: Double
        let windDeg: Int?
        let weather: [Weather]
        let clouds: Int
        let pop: Double?
        let uvi: Double
        
        var id: Int { dt }
        
        struct Temp: Codable, Equatable {
            let day: Double
            let min: Double
            let max: Double
            let night: Double
            let eve: Double
            let morn: Double
        }
        
        struct FeelsLike: Codable, Equatable {
            let day: Double
            let night: Double
            let eve: Double
            let morn: Double
        }
    }
    
    // MARK: - Weather Condition
    struct Weather: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
