import SwiftUI

struct WeatherColors {
    static let background = Color("BackgroundColor")
    static let cardBackground = Color("CardBackground")
    static let accent = Color("AccentColor")
    
    struct Light {
        static let primary = Color.blue
        static let secondary = Color.indigo.opacity(0.8)
        static let surface = Color.white.opacity(0.95)
        static let surfaceSecondary = Color.white.opacity(0.85)
        static let gradient1 = Color.blue.opacity(0.1)
        static let gradient2 = Color.indigo.opacity(0.05)
        static let shadow = Color.black.opacity(0.1)
    }
    
    struct Dark {
        static let primary = Color.cyan
        static let secondary = Color.teal.opacity(0.8)
        static let surface = Color.gray.opacity(0.7)
        static let surfaceSecondary = Color.gray.opacity(0.5)
        static let gradient1 = Color.cyan.opacity(0.15)
        static let gradient2 = Color.teal.opacity(0.1)
        static let shadow = Color.black.opacity(0.2)
    }
} 