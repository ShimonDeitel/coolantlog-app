import SwiftUI

/// Coolant Log — bespoke palette tuned to its domain.
enum Theme {
    static let accent = Color(red: 0.098, green: 0.659, blue: 0.549)
    static let background = Color(red: 0.016, green: 0.125, blue: 0.106)
    static let cardBackground = Color(.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
