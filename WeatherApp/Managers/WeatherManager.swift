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
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                error = AppError.invalidResponse
                return
            }
            
            let decoder = JSONDecoder()
            weatherData = try decoder.decode(WeatherData.self, from: data)
            error = nil
        } catch {
            self.error = AppError.networkError(error)
            print("Error fetching weather data: \(error)")
        }
    }

    private func getWeatherURL(for location: CLLocation) -> URL {
        // Add exclude parameter to get only needed data and reduce response size
        URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&exclude=minutely,alerts")!
    }
}
