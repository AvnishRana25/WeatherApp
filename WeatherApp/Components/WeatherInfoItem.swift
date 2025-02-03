import SwiftUI

struct WeatherInfoItem: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(tint)
                .symbolEffect(.bounce)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
            
            Text(value)
                .font(.headline)
                .bold()
                .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surfaceSecondary : WeatherColors.Light.surfaceSecondary)
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .contentShape(Rectangle())
        .hoverEffect()
    }
}
