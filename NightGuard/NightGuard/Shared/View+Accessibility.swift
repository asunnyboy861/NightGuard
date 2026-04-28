import SwiftUI

extension View {
    func accessibleButton(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }

    func accessibleStatus(label: String, value: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityValue(value)
    }
}
