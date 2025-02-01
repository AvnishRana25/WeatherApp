import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    private let apiKey = "0d2dd6d9fd0f44c7784e7acd9b397a41"
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var locationManager = LocationManager()
    
    @MainActor
    func refreshWeather() async {
        guard let location = locationManager.location else {
            error = AppError.locationNotAuthorized
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: getWeatherURL(for: location))
            
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
        }
    }
    
    private func getWeatherURL(for location: CLLocation) -> URL {
        URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric")!
    }
}
