import Foundation

enum AppLink {
    case privacyPolicy
    case termsOfService

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/6d3402b4-cdf5-4a86-ba39-5154945a200f"
        case .termsOfService:
            return "https://www.termsfeed.com/live/ebf6c86b-9726-4c18-b522-804156a6037a"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }

    var title: String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfService:
            return "Terms of Service"
        }
    }

    var icon: String {
        switch self {
        case .privacyPolicy:
            return "🔒"
        case .termsOfService:
            return "📄"
        }
    }
}
