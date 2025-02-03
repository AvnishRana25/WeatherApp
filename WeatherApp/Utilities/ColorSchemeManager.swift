import SwiftUI

struct WeatherColors {
    static let background = Color("BackgroundColor")
    static let cardBackground = Color("CardBackground")
    static let accent = Color("AccentColor")
    
    struct Light {
        static let primary = Color(.systemBlue)
        static let secondary = Color(.systemIndigo).opacity(0.8)
        static let surface = Color.white.opacity(0.95)
        static let surfaceSecondary = Color.white.opacity(0.85)
        static let gradient1 = Color(.systemBlue).opacity(0.1)
        static let gradient2 = Color(.systemIndigo).opacity(0.05)
        static let shadow = Color.black.opacity(0.1)
    }
    
    struct Dark {
        static let primary = Color(.systemCyan)
        static let secondary = Color(.systemTeal).opacity(0.8)
        static let surface = Color(.systemGray6).opacity(0.7)
        static let surfaceSecondary = Color(.systemGray5).opacity(0.5)
        static let gradient1 = Color(.systemCyan).opacity(0.15)
        static let gradient2 = Color(.systemTeal).opacity(0.1)
        static let shadow = Color.black.opacity(0.2)
    }
} 