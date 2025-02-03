import SwiftUI

struct WeatherColors {
    static let background = Color("BackgroundColor")
    static let cardBackground = Color("CardBackground")
    static let accent = Color("AccentColor")
    
    struct Light {
        static let primary = Color(.systemBlue)
        static let secondary = Color(.systemIndigo).opacity(0.8)
        static let surface = Color.white.opacity(0.9)
        static let surfaceSecondary = Color.white.opacity(0.7)
    }
    
    struct Dark {
        static let primary = Color(.systemCyan)
        static let secondary = Color(.systemTeal).opacity(0.8)
        static let surface = Color.black.opacity(0.5)
        static let surfaceSecondary = Color.black.opacity(0.3)
    }
} 