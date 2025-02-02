import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var locationName: String?
    private let locationManager = LocationManager()
    private let geocoder = CLGeocoder()
    
    init() {
        // Initialize and start fetching weather data when location is available
        locationManager.onLocationUpdate = { [weak self] location in
            Task {
                await self?.updateLocationName(for: location)
                await self?.refreshWeather()
            }
        }
    }
    
    @MainActor
    private func updateLocationName(for location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                if let locality = placemark.locality {
                    locationName = locality
                } else if let name = placemark.name {
                    locationName = name
                } else if let area = placemark.administrativeArea {
                    locationName = area
                }
            }
            print("Location name updated: \(locationName ?? "Unknown")")  // Debug print
        } catch {
            print("Geocoding error: \(error)")
            locationName = "Current Location"  // Fallback value
        }
    }
    
    @MainActor
    func refreshWeather() async {
        guard let location = locationManager.location else {
            error = AppError.locationNotAuthorized
            return
        }
        
        // Update location name first
        await updateLocationName(for: location)
        
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
            
            if httpResponse.statusCode != 200 {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("API Error: \(errorString)")
                    error = AppError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                } else {
                    error = AppError.invalidResponse
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                print("Attempting to decode data...")
                weatherData = try decoder.decode(WeatherData.self, from: data)
                
                // Print the received data structure
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                
                // Validate data
                guard let _ = weatherData?.current.temperature2m,
                      !weatherData!.daily.forecasts.isEmpty,
                      !weatherData!.hourly.forecasts.isEmpty else {
                    error = AppError.noWeatherData
                    return
                }
                
                error = nil
                print("Weather data decoded successfully: \(String(describing: weatherData?.current.temperature2m))")
            } catch let decodingError as DecodingError {
                print("Decoding error: \(decodingError)")
                switch decodingError {
                case .keyNotFound(let key, _):
                    self.error = AppError.decodingError("Missing key: \(key.stringValue)")
                case .typeMismatch(_, let context):
                    self.error = AppError.decodingError("Type mismatch: \(context.debugDescription)")
                default:
                    self.error = AppError.decodingError(decodingError.localizedDescription)
                }
            } catch {
                print("Network error: \(error)")
                self.error = AppError.networkError(error)
            }
        } catch {
            print("Network error: \(error)")
            self.error = AppError.networkError(error)
        }
    }

    private func getWeatherURL(for location: CLLocation) -> URL {
        var urlComponents = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        
        let queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m,is_day,pressure_msl,visibility,cloud_cover,uv_index"),
            URLQueryItem(name: "hourly", value: "temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m,is_day,precipitation_probability"),
            URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_probability_max"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "7")
        ]
        
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
