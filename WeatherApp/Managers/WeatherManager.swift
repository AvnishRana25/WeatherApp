import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    private let locationManager = LocationManager()
    
    init() {
        // Initialize and start fetching weather data when location is available
        locationManager.onLocationUpdate = { [weak self] location in
            Task {
                await self?.refreshWeather()
            }
        }
    }
    
    @MainActor
    func refreshWeather() async {
        guard let location = locationManager.location else {
            error = AppError.locationNotAuthorized
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = getWeatherURL(for: location)
            print("Requesting URL: \(url.absoluteString)") // Debug URL
            
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                error = AppError.invalidResponse
                return
            }
            
            print("API Response Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("API Error: \(errorString)")
                    error = AppError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                } else {
                    error = AppError.invalidResponse
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            weatherData = try decoder.decode(WeatherData.self, from: data)
            error = nil
            
            // Debug successful decode
            print("Weather data decoded successfully: \(String(describing: weatherData?.current.temperature))")
        } catch {
            print("Error fetching weather: \(error)")
            self.error = AppError.networkError(error)
        }
    }

    private func getWeatherURL(for location: CLLocation) -> URL {
        var urlComponents = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        
        let queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "current", value: "temperature,relative_humidity,weather_code,wind_speed_10m,wind_direction_10m,pressure_msl"),
            URLQueryItem(name: "hourly", value: "temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m"),
            URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
