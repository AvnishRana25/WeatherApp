import Foundation

struct WeatherData: Decodable, Equatable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    // MARK: - Current Weather
    struct Current: Codable, Equatable {
        let temp: Double
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
        }
    }
    
    // MARK: - Hourly Forecast
    // WeatherData.swift
    struct Hourly: Codable, Equatable, Identifiable {
        let id: Int      // Maps to API's "dt" (timestamp)
        let temp: Double
        let weather: [Weather]

        enum CodingKeys: String, CodingKey {
            case id = "dt"   // Explicit mapping
            case temp, weather
        }
    }

    struct Daily: Codable, Equatable, Identifiable {
        let id: Int      // Maps to API's "dt" (timestamp)
        let temp: DailyTemp
        let weather: [Weather]

        enum CodingKeys: String, CodingKey {
            case id = "dt"   // Explicit mapping
            case temp, weather
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
