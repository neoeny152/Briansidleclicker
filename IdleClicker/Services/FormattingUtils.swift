import Foundation

enum FormattingUtils {
    static func formatNumber(_ value: Double) -> String {
        if value < 0 {
            return "-" + formatNumber(-value)
        }

        if value < 1000 {
            if value == floor(value) {
                return String(format: "%.0f", value)
            }
            return String(format: "%.1f", value)
        }

        let suffixes = [
            (1_000_000_000_000_000_000_000_000.0, "Sep"),
            (1_000_000_000_000_000_000_000.0, "Sxt"),
            (1_000_000_000_000_000_000.0, "Qnt"),
            (1_000_000_000_000_000.0, "Qdr"),
            (1_000_000_000_000.0, "T"),
            (1_000_000_000.0, "B"),
            (1_000_000.0, "M"),
            (1_000.0, "K")
        ]

        for (threshold, suffix) in suffixes {
            if value >= threshold {
                let formatted = value / threshold
                if formatted >= 100 {
                    return String(format: "%.0f%@", formatted, suffix)
                } else if formatted >= 10 {
                    return String(format: "%.1f%@", formatted, suffix)
                } else {
                    return String(format: "%.2f%@", formatted, suffix)
                }
            }
        }

        return String(format: "%.0f", value)
    }

    static func formatTime(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds < 3600 {
            let mins = seconds / 60
            let secs = seconds % 60
            return "\(mins)m \(secs)s"
        } else {
            let hours = seconds / 3600
            let mins = (seconds % 3600) / 60
            return "\(hours)h \(mins)m"
        }
    }
}
