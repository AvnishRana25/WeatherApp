import Foundation

enum AppError: Error, LocalizedError {
    case locationNotAuthorized
    case networkError(Error)
    case invalidResponse
    case noWeatherData
    case invalidAPIKey
    
    var errorDescription: String? {
        switch self {
        case .locationNotAuthorized:
            return "Location access is required. Please enable it in Settings."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from weather service."
        case .noWeatherData:
            return "Unable to fetch weather data."
        case .invalidAPIKey:
            return "Invalid API key. Please check your API key and try again."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .locationNotAuthorized:
            return "Go to Settings → Privacy → Location Services to enable location access."
        case .networkError:
            return "Please check your internet connection and try again."
        case .invalidResponse, .noWeatherData:
            return "Pull down to refresh or try again later."
        case .invalidAPIKey:
            return "Please ensure your API key is valid and activated."
        }
    }
}