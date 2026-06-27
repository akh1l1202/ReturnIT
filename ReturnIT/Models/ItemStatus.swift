import UIKit

enum ItemStatus: String, Codable {
    case lost
    case found
    case resolved
    
    var title: String {
        switch self {
        case .lost:
            return "Lost"
        case .found:
            return "Found"
        case .resolved:
            return "Resolved"
        }
    }
    
    var badgeColor: UIColor {
        switch self {
        case .lost:
            return UIColor(red: 0.83, green: 0.21, blue: 0.23, alpha: 1.0) // Red for LOST
        case .found:
            return UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1.0) // Orange-Red for FOUND
        case .resolved:
            return UIColor(red: 0.14, green: 0.71, blue: 0.49, alpha: 1.0) // Green for RESOLVED
        }
    }
}
