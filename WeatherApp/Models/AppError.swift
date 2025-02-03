//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avnish Rana on 02/02/25.

import Foundation

enum AppError: Error, LocalizedError {
    case locationNotAuthorized
    case networkError(Error)
    case invalidResponse
    case noWeatherData
    case invalidAPIKey
    case decodingError(String)
    case emptyData
    
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
        case .decodingError(let message):
            return "Error processing weather data: \(message)"
        case .emptyData:
            return "No weather data available for this location."
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
        case .decodingError:
            return "Please check your internet connection and try again."
        case .emptyData:
            return "Please check your internet connection and try again."
        }
    }
}
