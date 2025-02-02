import Foundation

struct WeatherData: Decodable, Equatable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let timezoneOffset: Double
    let current: Current
    let hourly: Hourly
    let daily: Daily
    
    // MARK: - Current Weather
    struct Current: Codable, Equatable {
        let time: String
        let temperature: Double
        let relativeHumidity: Int
        let weatherCode: Int
        let windSpeed10m: Double
        let windDirection10m: Int
        let isDay: Int?
        let pressure: Double
        let visibility: Int
        let clouds: Int
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperature = "temperature_2m"
            case relativeHumidity = "relative_humidity_2m"
            case weatherCode = "weather_code"
            case windSpeed10m = "wind_speed_10m"
            case windDirection10m = "wind_direction_10m"
            case isDay = "is_day"
            case pressure = "pressure_msl"
            case visibility
            case clouds = "cloud_cover"
        }
        
        var weather: Weather { Weather(code: weatherCode) }
        
        // Add computed properties to match WeatherDetailsGrid usage
        var temp: Double { temperature }
        var humidity: Int { relativeHumidity }
        var windSpeed: Double { windSpeed10m }
        var uvIndex: Double { 0.0 }  // Default value since it's not in current weather
    }
    
    // MARK: - Hourly Forecast
    struct Hourly: Codable, Equatable {
        let time: [String]
        let temperature2m: [Double]
        let relativeHumidity2m: [Int]
        let weatherCode: [Int]
        let windSpeed10m: [Double]
        let windDirection10m: [Int]
        let isDay: [Int]
        let precipitationProbability: [Int]
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case relativeHumidity2m = "relative_humidity_2m"
            case weatherCode = "weather_code"
            case windSpeed10m = "wind_speed_10m"
            case windDirection10m = "wind_direction_10m"
            case isDay = "is_day"
            case precipitationProbability = "precipitation_probability"
        }
        
        var forecasts: [HourlyForecast] {
            var forecasts: [HourlyForecast] = []
            for i in 0..<time.count {
                forecasts.append(HourlyForecast(
                    time: time[i],
                    temp: temperature2m[i],
                    humidity: relativeHumidity2m[i],
                    weatherCode: weatherCode[i],
                    windSpeed: windSpeed10m[i],
                    windDirection: windDirection10m[i],
                    isDay: isDay[i],
                    precipitationProbability: precipitationProbability[i]
                ))
            }
            return forecasts
        }
    }
    
    // MARK: - Daily Forecast
    struct Daily: Codable, Equatable {
        let time: [String]
        let weatherCode: [Int]
        let temperature2mMax: [Double]
        let temperature2mMin: [Double]
        let sunrise: [String]
        let sunset: [String]
        let uvIndexMax: [Double]
        let precipitationProbability: [Int]
        
        enum CodingKeys: String, CodingKey {
            case time
            case weatherCode = "weather_code"
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
            case sunrise
            case sunset
            case uvIndexMax = "uv_index_max"
            case precipitationProbability = "precipitation_probability_max"
        }
        
        var forecasts: [DailyForecast] {
            var forecasts: [DailyForecast] = []
            for i in 0..<time.count {
                forecasts.append(DailyForecast(
                    time: time[i],
                    weatherCode: weatherCode[i],
                    tempMax: temperature2mMax[i],
                    tempMin: temperature2mMin[i],
                    sunrise: sunrise[i],
                    sunset: sunset[i],
                    uvIndex: uvIndexMax[i],
                    precipitationProbability: precipitationProbability[i]
                ))
            }
            return forecasts
        }
    }
    
    // MARK: - Helper Models
    struct HourlyForecast: Identifiable, Equatable {
        let time: String
        let temp: Double
        let humidity: Int
        let weatherCode: Int
        let windSpeed: Double
        let windDirection: Int
        let isDay: Int
        let precipitationProbability: Int
        
        var id: String { time }
        var weather: Weather { Weather(code: weatherCode) }
    }
    
    struct DailyForecast: Identifiable, Equatable {
        let time: String
        let weatherCode: Int
        let tempMax: Double
        let tempMin: Double
        let sunrise: String
        let sunset: String
        let uvIndex: Double
        let precipitationProbability: Int
        
        var id: String { time }
        var weather: Weather { Weather(code: weatherCode) }
    }
    
    // MARK: - Weather Helper
    struct Weather: Equatable {
        let code: Int
        
        var description: String {
            WeatherCode.description(for: code)
        }
        
        var main: String {
            WeatherCode.main(for: code)
        }
    }
}

// MARK: - Weather Code Helper
enum WeatherCode {
    static func description(for code: Int) -> String {
        switch code {
        case 0: return "Clear sky"
        case 1: return "Mainly clear"
        case 2: return "Partly cloudy"
        case 3: return "Overcast"
        case 45, 48: return "Foggy"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 77: return "Snow grains"
        case 80, 81, 82: return "Rain showers"
        case 85, 86: return "Snow showers"
        case 95: return "Thunderstorm"
        case 96, 99: return "Thunderstorm with hail"
        default: return "Unknown"
        }
    }
    
    static func main(for code: Int) -> String {
        switch code {
        case 0, 1: return "clear"
        case 2, 3: return "clouds"
        case 45, 48: return "fog"
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return "rain"
        case 71, 73, 75, 77, 85, 86: return "snow"
        case 95, 96, 99: return "thunderstorm"
        default: return "clouds"
        }
    }
}
