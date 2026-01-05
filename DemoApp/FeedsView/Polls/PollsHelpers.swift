//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import SwiftUI

private struct PollsBackgroundModifier: ViewModifier {
    let colors = Colors.shared
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(colors.background1))
            .cornerRadius(16)
    }
}

extension View {
    func withPollsBackground() -> some View {
        modifier(PollsBackgroundModifier())
    }
}

struct PollDateIndicatorView: View {
    let colors = Colors.shared
    
    var dateFormatter: (Date) -> String {
        PollsDateFormatter.shared.dateString(for:)
    }
    
    let date: Date
    
    var body: some View {
        Text(dateFormatter(date))
            .font(.subheadline)
            .foregroundColor(Color(colors.textLowEmphasis))
    }
}

class PollsDateFormatter: @unchecked Sendable {
    static let shared = PollsDateFormatter()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM dd HH:mm")
        return formatter
    }()
    
    func dateString(for date: Date) -> String {
        // Check if the date is today
        if Calendar.current.isDateInToday(date) {
            "Today"
        } else {
            // If it's not today, format the date normally
            dateFormatter.string(from: date)
        }
    }
}
