import Foundation

struct WeatherData: Decodable, Equatable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    // MARK: - Current Weather
    struct Current: Codable, Equatable {
        let temp: Double
        let feelsLike: Double // Added missing property
        let humidity: Int
        let windSpeed: Double
        let pressure: Int
        let uvIndex: Double
        let visibility: Int
        let clouds: Int
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity, pressure, visibility, clouds, weather
            case windSpeed = "wind_speed"
            case uvIndex = "uvi"
            case feelsLike = "feels_like" // Maps to OpenWeather's "feels_like"
        }
    }
    
    // MARK: - Hourly Forecast
    struct Hourly: Codable, Equatable, Identifiable {
        let dt: Int      // Timestamp from JSON
        let temp: Double
        let weather: [Weather]
        
        var id: Int { dt } // Computed for Identifiable
        
        enum CodingKeys: String, CodingKey {
            case dt, temp, weather
        }
    }

    // MARK: - Daily Forecast
    struct Daily: Codable, Equatable, Identifiable {
        let dt: Int      // Timestamp from JSON
        let temp: DailyTemp
        let weather: [Weather]
        
        var id: Int { dt } // Computed for Identifiable
        
        enum CodingKeys: String, CodingKey {
            case dt, temp, weather
        }
    }
    
    // MARK: - Daily Temperature
    struct DailyTemp: Codable, Equatable {
        let min: Double
        let max: Double
    }
    
    // MARK: - Weather Condition
    struct Weather: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
