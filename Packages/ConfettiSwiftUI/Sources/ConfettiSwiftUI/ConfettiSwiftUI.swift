import SwiftUI

public struct ConfettiCannon: View {
    @Binding private var counter: Int

    public init(
        counter: Binding<Int>,
        num: Int = 20,
        colors: [Color] = [.primary],
        confettiSize: CGFloat = 8,
        rainHeight: CGFloat = 600,
        radius: CGFloat = 300
    ) {
        self._counter = counter
    }

    public var body: some View {
        EmptyView()
    }
}
