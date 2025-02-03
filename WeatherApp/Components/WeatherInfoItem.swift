import SwiftUI

struct WeatherInfoItem: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(tint.opacity(colorScheme == .dark ? 0.2 : 0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(tint)
                    .symbolEffect(.bounce)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.secondary : WeatherColors.Light.secondary)
                
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? WeatherColors.Dark.primary : WeatherColors.Light.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? WeatherColors.Dark.surfaceSecondary : WeatherColors.Light.surfaceSecondary)
                .shadow(color: Color.primary.opacity(isHovered ? 0.15 : 0.1), 
                       radius: isHovered ? 8 : 5,
                       x: 0,
                       y: isHovered ? 4 : 2)
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
