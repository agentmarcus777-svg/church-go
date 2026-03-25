import SwiftUI

// MARK: - Haptic Feedback

extension View {
    func hapticOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.simultaneousGesture(TapGesture().onEnded {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        })
    }

    func hapticNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) -> some View {
        self.onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
    }
}

// MARK: - Conditional Modifier

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Rounded Border

extension View {
    func roundedBorder(_ color: Color, cornerRadius: CGFloat = Theme.radiusMD, lineWidth: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}
