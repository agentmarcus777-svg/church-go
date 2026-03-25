import SwiftUI

extension Color {
    // MARK: - Church Go Brand Colors

    /// Crimson Red — Primary action color
    static let cgCrimson = Color(hex: 0xC41E3A)

    /// Royal Gold — Accent, achievements, highlights
    static let cgGold = Color(hex: 0xD4AF37)

    /// Deep Red — Darker variant for gradients & pressed states
    static let cgDeepRed = Color(hex: 0x8B0000)

    /// Soft Ivory — Background
    static let cgIvory = Color(hex: 0xFFF8F0)

    /// Dark Charcoal — Text & dark surfaces
    static let cgCharcoal = Color(hex: 0x1C1C1E)

    // MARK: - Semantic Colors

    static let cgBackground = cgIvory
    static let cgSurface = Color.white
    static let cgPrimaryText = cgCharcoal
    static let cgSecondaryText = cgCharcoal.opacity(0.5)
    static let cgSuccess = Color(hex: 0x34C759)
    static let cgWarning = Color(hex: 0xFF9500)

    // MARK: - Gradients

    static var cgCrimsonGradient: LinearGradient {
        LinearGradient(
            colors: [cgCrimson, cgDeepRed],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var cgGoldGradient: LinearGradient {
        LinearGradient(
            colors: [cgGold, Color(hex: 0xB8860B)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cgSunriseGradient: LinearGradient {
        LinearGradient(
            colors: [cgCrimson, cgGold],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Hex Initializer

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
