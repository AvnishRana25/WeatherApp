import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    private let apiKey = "0d2dd6d9fd0f44c7784e7acd9b397a41"
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
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                error = AppError.invalidResponse
                return
            }
            
            // Debug response
            print("API Response Status: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
            
            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = errorJson["message"] as? String {
                    print("API Error: \(message)")
                    error = AppError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message]))
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
            print("Weather data decoded successfully: \(String(describing: weatherData?.current.temp))")
        } catch {
            print("Decoding error: \(error)")
            self.error = AppError.networkError(error)
        }
    }

    private func getWeatherURL(for location: CLLocation) -> URL {
        // Using v2.5 of the API with correct parameters
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&exclude=minutely,alerts"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        return url
    }
}
