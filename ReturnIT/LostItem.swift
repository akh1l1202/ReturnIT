import Foundation

struct LostItem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var category: String
    var status: String
    var location: String
    var date: String
    var description: String
    var imageFileName: String?
    
    var posterEmail: String?
    var posterResolved: Bool = false
    var finderResolvedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, category, status, location, date, description, imageFileName, posterEmail, posterResolved, finderResolvedEmail
    }
    
    init(id: String = UUID().uuidString, title: String, category: String, status: String, location: String, date: String, description: String, imageFileName: String? = nil, posterEmail: String? = nil, posterResolved: Bool = false, finderResolvedEmail: String? = nil) {
        self.id = id
        self.title = title
        self.category = category
        self.status = status
        self.location = location
        self.date = date
        self.description = description
        self.imageFileName = imageFileName
        self.posterEmail = posterEmail
        self.posterResolved = posterResolved
        self.finderResolvedEmail = finderResolvedEmail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Unknown"
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "Unknown"
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? "Unknown"
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? "Unknown"
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? "Unknown"
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? "No description"
        self.imageFileName = try container.decodeIfPresent(String.self, forKey: .imageFileName)
        self.posterEmail = try container.decodeIfPresent(String.self, forKey: .posterEmail)
        self.posterResolved = try container.decodeIfPresent(Bool.self, forKey: .posterResolved) ?? false
        self.finderResolvedEmail = try container.decodeIfPresent(String.self, forKey: .finderResolvedEmail)
    }
}
